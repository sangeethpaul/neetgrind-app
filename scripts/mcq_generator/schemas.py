"""
schemas.py — Pydantic v2 models for each stage of the MCQ pipeline.

Stage 1 → ExtractedFact      (extraction prompt output)
Stage 2 → QuestionDraft      (question prompt output)
Stage 3 → MCQRecord          (distractor prompt output — final form)

MCQRecord matches the public.questions table schema exactly.
"""

from __future__ import annotations
from typing import Literal
from pydantic import BaseModel, Field, field_validator


class ExtractedFact(BaseModel):
    """A single key fact extracted from an NCERT chapter chunk."""

    fact: str = Field(
        description="A single, self-contained testable fact or concept from the chapter."
    )
    category: str = Field(
        description="Category: definition | formula | process | comparison | application"
    )

    @field_validator("fact")
    @classmethod
    def fact_not_empty(cls, v: str) -> str:
        v = v.strip()
        if len(v) < 10:
            raise ValueError("Fact too short to be meaningful")
        return v


class ExtractionOutput(BaseModel):
    """Wrapper for the list of facts returned by the extraction prompt."""

    facts: list[ExtractedFact] = Field(
        description="List of key testable facts extracted from the chapter.",
        min_length=1,
        max_length=100,
    )


class QuestionDraft(BaseModel):
    """Question and correct answer generated from a single fact."""

    question_text: str = Field(
        description="A clear, concise MCQ question. Must end with '?'"
    )
    correct_answer: str = Field(
        description="The correct answer — a short phrase (< 80 chars)."
    )
    explanation: str = Field(
        description="A 1-2 sentence explanation of why this answer is correct, "
                    "with the key concept highlighted."
    )

    @field_validator("question_text")
    @classmethod
    def question_ends_with_mark(cls, v: str) -> str:
        v = v.strip()
        if not v.endswith("?"):
            v += "?"
        return v

    @field_validator("correct_answer", "explanation")
    @classmethod
    def strip_whitespace(cls, v: str) -> str:
        return v.strip()


class DistractorOutput(BaseModel):
    """Three plausible but incorrect options for a given question."""

    distractor_1: str = Field(description="First plausible wrong option.")
    distractor_2: str = Field(description="Second plausible wrong option.")
    distractor_3: str = Field(description="Third plausible wrong option.")

    @field_validator("distractor_1", "distractor_2", "distractor_3")
    @classmethod
    def strip_and_validate(cls, v: str) -> str:
        v = v.strip()
        if len(v) < 2:
            raise ValueError("Distractor too short")
        return v


class MCQRecord(BaseModel):
    """
    Final validated MCQ record — mirrors the public.questions table exactly.
    topic_id is set at write-time from the config's CHAPTER_TOPIC_MAP.
    """

    topic_id: int
    question_text: str
    option_a: str
    option_b: str
    option_c: str
    option_d: str
    correct_option: Literal["A", "B", "C", "D"]
    explanation: str

    @classmethod
    def assemble(
        cls,
        *,
        topic_id: int,
        draft: QuestionDraft,
        distractors: DistractorOutput,
    ) -> "MCQRecord":
        """
        Randomly place the correct answer among the four options.
        Option A is always the correct answer here for simplicity; the NEET
        app shuffles options client-side before displaying them.
        """
        import random

        options = [
            draft.correct_answer,
            distractors.distractor_1,
            distractors.distractor_2,
            distractors.distractor_3,
        ]
        random.shuffle(options)

        labels = ["A", "B", "C", "D"]
        correct_idx = options.index(draft.correct_answer)

        return cls(
            topic_id=topic_id,
            question_text=draft.question_text,
            option_a=options[0],
            option_b=options[1],
            option_c=options[2],
            option_d=options[3],
            correct_option=labels[correct_idx],
            explanation=draft.explanation,
        )

    def to_sql_row(self) -> str:
        return (
            f"({self.topic_id}, "
            f"'{esc(self.question_text)}', "
            f"'{esc(self.option_a)}', "
            f"'{esc(self.option_b)}', "
            f"'{esc(self.option_c)}', "
            f"'{esc(self.option_d)}', "
            f"'{self.correct_option}', "
            f"'{esc(self.explanation)}')"
        )


def esc(s: str) -> str:
    """Escape single quotes for SQL insertion."""
    return s.replace("'", "''")


class JudgeOutput(BaseModel):
    """Output for the COLING 2025 Evaluation stage."""

    score: int = Field(description="Quality score from 1-10.")
    reason: str = Field(description="Brief justification for the score.")
    pedagogical_value: str = Field(description="How well it tests core concepts.")
    clarity_score: int = Field(description="Clarity of the question text.")


-- Delete the placeholder physics questions that were accidentally applied to all subjects
DELETE FROM public.questions 
WHERE question_text IN (
  'A body is said to be in equilibrium when the net force acting on it is:',
  'Newton''s first law of motion defines:',
  'A 5 kg object accelerates at 3 m/s². What is the net force?',
  'The unit of momentum is:',
  'When a gun is fired, the gun recoils. This demonstrates:',
  'The rate of change of momentum of a body is equal to the:',
  'A body of mass 10 kg is moving with velocity 5 m/s. Its momentum is:',
  'Friction force is always:',
  'The coefficient of static friction is always:',
  'An impulse of 20 N⋅s is applied to a body. The change in momentum is:',
  'Inertia of a body depends on its:',
  'A 2 kg ball moving at 4 m/s collides with a wall and rebounds at 4 m/s. Change in momentum is:'
);

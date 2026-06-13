import Link from "next/link";
import { buttonVariants } from "@/components/ui/button";
import { VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";
import { ReactNode } from "react";

interface LinkButtonProps extends VariantProps<typeof buttonVariants> {
  href: string;
  className?: string;
  children: ReactNode;
}

/**
 * A Next.js <Link> styled as a Button.
 * Use this instead of <Button asChild><Link ...> since the Shadcn
 * button here uses @base-ui/react which does not support the asChild pattern.
 */
export function LinkButton({ href, variant, size, className, children }: LinkButtonProps) {
  return (
    <Link href={href} className={cn(buttonVariants({ variant, size }), className)}>
      {children}
    </Link>
  );
}

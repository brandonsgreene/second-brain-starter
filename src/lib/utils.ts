// Utility function for merging Tailwind CSS class names.
// This is a common pattern in React + Tailwind projects.
// It lets you conditionally combine CSS classes without conflicts.

import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

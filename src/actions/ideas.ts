"use server";

// Server Actions are functions that run on the server, not in the browser.
// They're perfect for database operations because they keep your
// database credentials safe (they never get sent to the browser).

import { prisma } from "@/lib/prisma";
import { revalidatePath } from "next/cache";

// The category-to-emoji mapping — pick an emoji for each category!
const categoryEmojis: Record<string, string> = {
  general: "💡",
  school: "📚",
  creative: "🎨",
  music: "🎵",
  tech: "💻",
  goals: "🎯",
  journal: "📝",
  funny: "😂",
};

export async function createIdea(formData: FormData) {
  // FormData comes from the HTML form. We extract each field by name.
  const title = formData.get("title") as string;
  const content = formData.get("content") as string;
  const category = (formData.get("category") as string) || "general";

  // Don't save if the title is empty
  if (!title?.trim()) return;

  // Create a new row in the Idea table
  await prisma.idea.create({
    data: {
      title: title.trim(),
      content: content?.trim() || "",
      category,
      emoji: categoryEmojis[category] || "💡",
    },
  });

  // Tell Next.js to refresh the home page so the new idea shows up
  revalidatePath("/");
}

export async function deleteIdea(id: string) {
  await prisma.idea.delete({
    where: { id },
  });

  revalidatePath("/");
}

export async function togglePin(id: string) {
  // First, find the current idea to check its pinned status
  const idea = await prisma.idea.findUnique({ where: { id } });
  if (!idea) return;

  // Flip the pinned status (true becomes false, false becomes true)
  await prisma.idea.update({
    where: { id },
    data: { pinned: !idea.pinned },
  });

  revalidatePath("/");
}

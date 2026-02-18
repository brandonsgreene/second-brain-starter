// This is the home page of your Second Brain!
// It's a "Server Component" — it runs on the server and can
// directly talk to the database. No loading spinners needed!

import { prisma } from "@/lib/prisma";
import { IdeaCard } from "@/components/idea-card";
import { NewIdeaForm } from "@/components/new-idea-form";
import { Brain } from "lucide-react";

export default async function HomePage() {
  // Fetch all ideas from the database, pinned ones first, then newest first
  const ideas = await prisma.idea.findMany({
    orderBy: [{ pinned: "desc" }, { createdAt: "desc" }],
  });

  return (
    <main className="mx-auto max-w-4xl px-4 py-8">
      {/* Header */}
      <div className="mb-8 text-center">
        <div className="mb-3 flex items-center justify-center gap-3">
          <Brain className="h-10 w-10 text-primary" />
          <h1 className="text-4xl font-bold tracking-tight">
            My Second Brain
          </h1>
        </div>
        <p className="text-muted-foreground">
          A home for all your ideas, notes, and random thoughts
        </p>
      </div>

      {/* New Idea Form */}
      <div className="mb-8">
        <NewIdeaForm />
      </div>

      {/* Ideas Grid */}
      {ideas.length > 0 ? (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {ideas.map((idea) => (
            <IdeaCard
              key={idea.id}
              id={idea.id}
              title={idea.title}
              content={idea.content}
              category={idea.category}
              emoji={idea.emoji}
              pinned={idea.pinned}
              createdAt={idea.createdAt}
            />
          ))}
        </div>
      ) : (
        // Empty state — shown when there are no ideas yet
        <div className="mt-12 text-center">
          <span className="text-6xl">🧠</span>
          <h2 className="mt-4 text-xl font-semibold">
            Your brain is empty... for now!
          </h2>
          <p className="mt-2 text-muted-foreground">
            Add your first idea above to get started.
          </p>
        </div>
      )}

      {/* Idea count footer */}
      {ideas.length > 0 && (
        <p className="mt-8 text-center text-sm text-muted-foreground">
          {ideas.length} idea{ideas.length === 1 ? "" : "s"} in your brain
        </p>
      )}
    </main>
  );
}

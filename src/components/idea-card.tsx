"use client";

// This component needs "use client" because it uses onClick handlers.
// In Next.js, components are "server components" by default (they run
// on the server). But when you need interactivity like button clicks,
// you switch to a "client component" so it runs in the browser too.

import { deleteIdea, togglePin } from "@/actions/ideas";
import { Pin, Trash2 } from "lucide-react";

// Define what data this component expects to receive
interface IdeaCardProps {
  id: string;
  title: string;
  content: string;
  category: string;
  emoji: string;
  pinned: boolean;
  createdAt: Date;
}

// Category colors — each category gets its own color scheme
const categoryColors: Record<string, string> = {
  general: "bg-gray-100 text-gray-700",
  school: "bg-blue-100 text-blue-700",
  creative: "bg-pink-100 text-pink-700",
  music: "bg-purple-100 text-purple-700",
  tech: "bg-emerald-100 text-emerald-700",
  goals: "bg-amber-100 text-amber-700",
  journal: "bg-cyan-100 text-cyan-700",
  funny: "bg-orange-100 text-orange-700",
};

export function IdeaCard({
  id,
  title,
  content,
  category,
  emoji,
  pinned,
  createdAt,
}: IdeaCardProps) {
  return (
    <div
      className={`group relative rounded-xl border bg-card p-5 shadow-sm transition-all hover:shadow-md ${
        pinned ? "ring-2 ring-primary/30" : ""
      }`}
    >
      {/* Top row: emoji + category badge */}
      <div className="mb-3 flex items-center justify-between">
        <span className="text-2xl">{emoji}</span>
        <span
          className={`rounded-full px-2.5 py-0.5 text-xs font-medium ${
            categoryColors[category] || categoryColors.general
          }`}
        >
          {category}
        </span>
      </div>

      {/* Title */}
      <h3 className="mb-1.5 text-lg font-semibold leading-tight">{title}</h3>

      {/* Content preview */}
      {content && (
        <p className="mb-3 line-clamp-3 text-sm text-muted-foreground">
          {content}
        </p>
      )}

      {/* Bottom row: date + action buttons */}
      <div className="flex items-center justify-between">
        <span className="text-xs text-muted-foreground">
          {createdAt.toLocaleDateString("en-US", {
            month: "short",
            day: "numeric",
          })}
        </span>

        {/* These buttons are hidden until you hover over the card */}
        <div className="flex gap-1 opacity-0 transition-opacity group-hover:opacity-100">
          <button
            onClick={() => togglePin(id)}
            className={`rounded-lg p-1.5 transition-colors hover:bg-accent ${
              pinned ? "text-primary" : "text-muted-foreground"
            }`}
            title={pinned ? "Unpin" : "Pin to top"}
          >
            <Pin className="h-4 w-4" />
          </button>
          <button
            onClick={() => deleteIdea(id)}
            className="rounded-lg p-1.5 text-muted-foreground transition-colors hover:bg-red-100 hover:text-red-600"
            title="Delete idea"
          >
            <Trash2 className="h-4 w-4" />
          </button>
        </div>
      </div>
    </div>
  );
}

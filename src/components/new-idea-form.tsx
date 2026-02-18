"use client";

// This is the form for adding new ideas.
// It uses a <form> with the "action" attribute pointing to a Server Action.
// When the form is submitted, Next.js automatically sends the data
// to the server and runs the createIdea function.

import { createIdea } from "@/actions/ideas";
import { Plus } from "lucide-react";
import { useRef } from "react";

const categories = [
  { value: "general", label: "General" },
  { value: "school", label: "School" },
  { value: "creative", label: "Creative" },
  { value: "music", label: "Music" },
  { value: "tech", label: "Tech" },
  { value: "goals", label: "Goals" },
  { value: "journal", label: "Journal" },
  { value: "funny", label: "Funny" },
];

export function NewIdeaForm() {
  // useRef lets us access the form element so we can reset it after submit
  const formRef = useRef<HTMLFormElement>(null);

  return (
    <form
      ref={formRef}
      action={async (formData) => {
        await createIdea(formData);
        formRef.current?.reset(); // Clear the form after saving
      }}
      className="rounded-xl border bg-card p-5 shadow-sm"
    >
      <h2 className="mb-4 text-lg font-semibold">New Idea</h2>

      {/* Title input */}
      <input
        name="title"
        type="text"
        placeholder="What's on your mind?"
        required
        className="mb-3 w-full rounded-lg border bg-background px-4 py-2.5 text-sm outline-none transition-colors placeholder:text-muted-foreground focus:border-primary focus:ring-2 focus:ring-primary/20"
      />

      {/* Content textarea */}
      <textarea
        name="content"
        placeholder="Add more details... (optional)"
        rows={3}
        className="mb-3 w-full resize-none rounded-lg border bg-background px-4 py-2.5 text-sm outline-none transition-colors placeholder:text-muted-foreground focus:border-primary focus:ring-2 focus:ring-primary/20"
      />

      {/* Category select + submit button */}
      <div className="flex items-center gap-3">
        <select
          name="category"
          defaultValue="general"
          className="rounded-lg border bg-background px-3 py-2 text-sm outline-none transition-colors focus:border-primary focus:ring-2 focus:ring-primary/20"
        >
          {categories.map((cat) => (
            <option key={cat.value} value={cat.value}>
              {cat.label}
            </option>
          ))}
        </select>

        <button
          type="submit"
          className="ml-auto flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
        >
          <Plus className="h-4 w-4" />
          Save Idea
        </button>
      </div>
    </form>
  );
}

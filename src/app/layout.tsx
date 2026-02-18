import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

// These load custom fonts from Google Fonts automatically.
// Next.js optimizes them so they load fast.
const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

// This metadata shows up in your browser tab and in search results.
export const metadata: Metadata = {
  title: "My Second Brain",
  description: "A place for all my ideas, notes, and cool stuff",
};

// This is the root layout — it wraps every page in your app.
// Think of it like the outer shell that stays the same
// no matter which page you're on.
export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} font-[family-name:var(--font-geist-sans)] antialiased`}
      >
        {children}
      </body>
    </html>
  );
}

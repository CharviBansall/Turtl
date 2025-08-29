import type React from "react"
import type { Metadata } from "next"
import "./globals.css"

export const metadata: Metadata = {
  title: "Turtl - AI-Powered Task Scheduling for macOS",
  description:
    "Schedule your tasks effortlessly with Turtl, the intelligent macOS menu bar app that uses AI to organize your calendar with just one prompt.",
  generator: "v0.app",
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en" className="antialiased">
      <body className="font-sans">{children}</body>
    </html>
  )
}

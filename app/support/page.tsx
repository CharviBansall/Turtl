"use client"

import type React from "react"

import { useState } from "react"

export default function SupportPage() {
  const [message, setMessage] = useState("")
  const [email, setEmail] = useState("")
  const [name, setName] = useState("")
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [isSubmitted, setIsSubmitted] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsSubmitting(true)

    // Create mailto link with form data
    const subject = encodeURIComponent("Turtl Support Request")
    const body = encodeURIComponent(`Name: ${name}\nEmail: ${email}\n\nMessage:\n${message}`)
    const mailtoLink = `mailto:charvibansal2006@gmail.com?subject=${subject}&body=${body}`

    // Open default email client
    window.location.href = mailtoLink

    setIsSubmitting(false)
    setIsSubmitted(true)

    // Reset form after 3 seconds
    setTimeout(() => {
      setIsSubmitted(false)
      setMessage("")
      setEmail("")
      setName("")
    }, 3000)
  }

  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <header className="border-b border-gray-200">
        <div className="max-w-6xl mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <img src="/turtl-logo.png" alt="Turtl" className="w-8 h-8" />
              <span className="text-xl font-semibold text-gray-900">Turtl</span>
            </div>
            <a href="/" className="text-blue-600 hover:text-blue-700 font-medium">
              ← Back to Home
            </a>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-6 py-16">
        <div className="text-center mb-16">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">How can we help?</h1>
          <p className="text-xl text-gray-600">Get support for Turtl and find answers to common questions</p>
        </div>

        {/* Contact Form Section */}
        <div className="bg-gray-50 rounded-2xl p-8 mb-12">
          <h2 className="text-2xl font-semibold text-gray-900 mb-6">Send us a message</h2>
          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="grid md:grid-cols-2 gap-6">
              <div>
                <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
                  Name
                </label>
                <input
                  type="text"
                  id="name"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  required
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Your name"
                />
              </div>
              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                  Email
                </label>
                <input
                  type="email"
                  id="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="your@email.com"
                />
              </div>
            </div>
            <div>
              <label htmlFor="message" className="block text-sm font-medium text-gray-700 mb-2">
                Message
              </label>
              <textarea
                id="message"
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                required
                rows={6}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                placeholder="How can we help you?"
              />
            </div>
            <button
              type="submit"
              disabled={isSubmitting || isSubmitted}
              className="w-full md:w-auto px-8 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors font-medium"
            >
              {isSubmitting ? "Sending..." : isSubmitted ? "Message Sent!" : "Send Message"}
            </button>
          </form>
        </div>

        {/* FAQ Section */}
        <div className="mb-12">
          <h2 className="text-2xl font-semibold text-gray-900 mb-8">Frequently Asked Questions</h2>
          <div className="space-y-6">
            <div className="border border-gray-200 rounded-lg p-6">
              <h3 className="font-semibold text-gray-900 mb-2">How does Turtl schedule my tasks?</h3>
              <p className="text-gray-600">
                Turtl uses AI to analyze your task description, priority level, and available calendar time to
                automatically find the best time slot for your task. Simply type what you need to do, set the priority,
                and Turtl handles the rest.
              </p>
            </div>

            <div className="border border-gray-200 rounded-lg p-6">
              <h3 className="font-semibold text-gray-900 mb-2">Which calendar apps does Turtl work with?</h3>
              <p className="text-gray-600">
                Turtl integrates with macOS Calendar, which syncs with iCloud, Google Calendar, Outlook, and other
                calendar services you have connected to your Mac.
              </p>
            </div>

            <div className="border border-gray-200 rounded-lg p-6">
              <h3 className="font-semibold text-gray-900 mb-2">Can I customize the priority levels?</h3>
              <p className="text-gray-600">
                Currently, Turtl offers three priority levels: Low, Medium, and High. These help the AI understand how
                urgently you need to complete each task when scheduling.
              </p>
            </div>

            <div className="border border-gray-200 rounded-lg p-6">
              <h3 className="font-semibold text-gray-900 mb-2">Is my calendar data secure?</h3>
              <p className="text-gray-600">
                Yes, Turtl only accesses your calendar data locally on your Mac. We don't store or transmit your
                personal calendar information to external servers.
              </p>
            </div>

            <div className="border border-gray-200 rounded-lg p-6">
              <h3 className="font-semibold text-gray-900 mb-2">How do I uninstall Turtl?</h3>
              <p className="text-gray-600">
                To uninstall Turtl, simply drag the app from your Applications folder to the Trash. You can also quit
                Turtl from the menu bar by clicking the turtle icon and selecting "Quit Turtl."
              </p>
            </div>
          </div>
        </div>

        {/* System Requirements */}
        <div className="bg-blue-50 rounded-2xl p-8">
          <h2 className="text-2xl font-semibold text-gray-900 mb-6">System Requirements</h2>
          <div className="grid md:grid-cols-2 gap-6">
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">Minimum Requirements</h3>
              <ul className="text-gray-600 space-y-1">
                <li>• macOS 12.0 or later</li>
                <li>• 50 MB available storage</li>
                <li>• Internet connection for AI features</li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">Recommended</h3>
              <ul className="text-gray-600 space-y-1">
                <li>• macOS 13.0 or later</li>
                <li>• Apple Silicon (M1/M2) processor</li>
                <li>• Calendar app configured</li>
              </ul>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-gray-200 bg-gray-50">
        <div className="max-w-6xl mx-auto px-6 py-8">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <div className="flex items-center space-x-3 mb-4 md:mb-0">
              <img src="/turtl-logo.png" alt="Turtl" className="w-6 h-6" />
              <span className="text-gray-600">© 2025 Turtl. All rights reserved.</span>
            </div>
            <div className="flex space-x-6">
              <a href="/" className="text-gray-600 hover:text-gray-900">
                Privacy Policy
              </a>
              <a href="/" className="text-gray-600 hover:text-gray-900">
                Terms of Service
              </a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}

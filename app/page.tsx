import { Button } from "@/components/ui/button"
import { Clock, Zap, Brain } from "lucide-react"

export default function TurtlLandingPage() {
  return (
    <div className="min-h-screen bg-background">
      {/* Navigation */}
      <nav className="sticky top-0 z-50 bg-background/95 backdrop-blur-xl border-b border-border/50">
        <div className="max-w-6xl mx-auto px-6">
          <div className="flex justify-between items-center h-11">
            <div className="flex items-center space-x-2">
              <div className="w-7 h-7">
                <img src="/turtl-logo.png" alt="Turtl" className="w-full h-full" />
              </div>
              <span className="font-semibold text-lg text-foreground tracking-tight">Turtl</span>
            </div>
            <div className="hidden md:flex items-center space-x-8">
              <a href="#features" className="text-foreground/70 hover:text-foreground transition-colors text-sm">
                Features
              </a>
              <a href="#how-it-works" className="text-foreground/70 hover:text-foreground transition-colors text-sm">
                How it Works
              </a>
              <Button
                size="sm"
                className="apple-button bg-primary hover:bg-primary/90 text-primary-foreground rounded-full px-4 py-1.5 text-sm font-medium"
                asChild
              >
                <a
                  href="https://apps.apple.com/us/app/turtl/id6751080661?mt=12"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Download
                </a>
              </Button>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="pt-16 pb-20 lg:pt-24 lg:pb-32">
        <div className="max-w-6xl mx-auto px-6 text-center">
          <div className="space-y-8 max-w-4xl mx-auto">
            <h1 className="font-semibold text-5xl lg:text-7xl text-foreground leading-tight tracking-tight">
              Schedule tasks with <span className="text-primary">just one prompt</span>
            </h1>
            <p className="text-xl lg:text-2xl text-muted-foreground leading-relaxed max-w-2xl mx-auto font-normal">
              Turtl lives in your menu bar, ready to intelligently schedule your tasks with AI.
            </p>
            <div className="flex justify-center pt-4">
              <Button
                size="lg"
                className="apple-button bg-primary hover:bg-primary/90 text-primary-foreground rounded-full px-8 py-3 text-base font-medium"
                asChild
              >
                <a
                  href="https://apps.apple.com/us/app/turtl/id6751080661?mt=12"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Download for macOS
                </a>
              </Button>
            </div>
            <p className="text-sm text-muted-foreground pt-2">Free to try • macOS 12 or later</p>
          </div>

          {/* Hero Image */}
          <div className="mt-16 lg:mt-24">
            <div className="relative max-w-4xl mx-auto">
              <div className="bg-card rounded-3xl shadow-2xl border border-border/50 overflow-hidden">
                <img
                  src="/turtl-hero.jpg"
                  alt="Turtl menu bar app interface showing task scheduling"
                  className="w-full h-auto"
                />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 lg:py-32 bg-muted/30">
        <div className="max-w-6xl mx-auto px-6">
          <div className="text-center space-y-4 mb-20">
            <h2 className="font-semibold text-4xl lg:text-6xl text-foreground tracking-tight">
              Effortlessly intelligent
            </h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto font-normal">
              Three powerful features that transform how you schedule tasks.
            </p>
          </div>

          <div className="grid lg:grid-cols-3 gap-12">
            <div className="text-center space-y-6">
              <div className="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto">
                <Zap className="h-8 w-8 text-primary" />
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-2xl text-foreground">One prompt</h3>
                <p className="text-muted-foreground leading-relaxed">
                  Simply describe your task in natural language. Turtl understands context and schedules it perfectly.
                </p>
              </div>
            </div>

            <div className="text-center space-y-6">
              <div className="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto">
                <Brain className="h-8 w-8 text-primary" />
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-2xl text-foreground">Smart priority</h3>
                <p className="text-muted-foreground leading-relaxed">
                  Set priority levels and let AI determine optimal time slots based on your existing calendar.
                </p>
              </div>
            </div>

            <div className="text-center space-y-6">
              <div className="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto">
                <Clock className="h-8 w-8 text-primary" />
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-2xl text-foreground">Menu bar ready</h3>
                <p className="text-muted-foreground leading-relaxed">
                  Always accessible from your menu bar. No need to open heavy apps or switch contexts.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* How It Works */}
      <section id="how-it-works" className="py-20 lg:py-32">
        <div className="max-w-6xl mx-auto px-6">
          <div className="text-center space-y-4 mb-20">
            <h2 className="font-semibold text-4xl lg:text-6xl text-foreground tracking-tight">Three simple steps</h2>
          </div>

          <div className="grid lg:grid-cols-3 gap-16">
            <div className="text-center space-y-6">
              <div className="w-20 h-20 bg-primary rounded-full flex items-center justify-center mx-auto">
                <span className="text-primary-foreground font-semibold text-2xl">1</span>
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-2xl text-foreground">Describe your task</h3>
                <p className="text-muted-foreground leading-relaxed">
                  Click Turtl in your menu bar and type the task you need to complete.
                </p>
              </div>
            </div>

            <div className="text-center space-y-6">
              <div className="w-20 h-20 bg-primary rounded-full flex items-center justify-center mx-auto">
                <span className="text-primary-foreground font-semibold text-2xl">2</span>
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-2xl text-foreground">Set priority</h3>
                <p className="text-muted-foreground leading-relaxed">
                  Choose your priority level. Turtl learns your patterns and preferences over time.
                </p>
              </div>
            </div>

            <div className="text-center space-y-6">
              <div className="w-20 h-20 bg-primary rounded-full flex items-center justify-center mx-auto">
                <span className="text-primary-foreground font-semibold text-2xl">3</span>
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-2xl text-foreground">AI schedules it</h3>
                <p className="text-muted-foreground leading-relaxed">
                  Our AI finds the perfect time slot and adds it to your calendar automatically.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 lg:py-32 bg-muted/30">
        <div className="max-w-4xl mx-auto text-center px-6">
          <div className="space-y-8">
            <h2 className="font-semibold text-4xl lg:text-6xl text-foreground tracking-tight">Ready to get started?</h2>
            <p className="text-xl text-muted-foreground font-normal">
              Join thousands who've made scheduling effortless.
            </p>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-border/50 bg-background">
        <div className="max-w-6xl mx-auto px-6 py-12">
          <div className="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
            <div className="flex items-center space-x-2">
              <div className="w-7 h-7">
                <img src="/turtl-logo.png" alt="Turtl" className="w-full h-full" />
              </div>
              <span className="font-semibold text-lg text-foreground tracking-tight">Turtl</span>
            </div>

            <div className="flex items-center space-x-8 text-sm text-muted-foreground">
              <a href="#" className="hover:text-foreground transition-colors">
                Privacy Policy
              </a>
              <a href="#" className="hover:text-foreground transition-colors">
                Terms of Service
              </a>
              <a href="/support" className="hover:text-foreground transition-colors">
                Support
              </a>
            </div>
          </div>

          <div className="border-t border-border/50 mt-8 pt-8 text-center">
            <p className="text-sm text-muted-foreground">Copyright © 2025 Turtl. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}

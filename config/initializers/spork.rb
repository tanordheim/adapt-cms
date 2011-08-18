if defined?(Spork)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
end

// Import and register all your controllers

import { application } from "./application"

// If you have any custom controllers, register them here
// Example: import HelloController from './hello_controller'
// application.register("hello", HelloController)

// This will register all controllers in this directory automatically
// We're not using eagerLoadControllersFrom as it's causing issues with esbuild
# Migration Guidance

- This Flutter project (`/home/du/Freelance/albert/kemenhut_aren_flutter`) must mirror the legacy Android implementation located at `/home/du/Freelance/albert/Kemenhut_aren/app/src`. Treat the Java source as the functional and visual source of truth.

- When adding or updating features, inspect the Java activities, fragments, and layouts to understand the expected UI flow, state handling, network calls, and edge cases. Port those behaviours into the equivalent Flutter widgets, services, and navigation stacks.

- Match screen structure, component hierarchy, and styling. Reuse asset names, icons, colors, and string resources from the Android project wherever possible so the Flutter build looks identical unless a deliberate design update is required.

- Keep logic parity: mirror data models, validation rules, serialization formats, and API request shapes. If the Java code interacts with specific endpoints or handles errors in a particular way, replicate that flow so backend compatibility remains intact.

- Document any intentional deviations from the Android baseline directly in the related Dart files and update this note whenever the migration strategy changes.

- Before delivering a feature, cross-check the Flutter behaviour against the Android version by walking through the same screens and scenarios. Add or update automated tests (`flutter test`) to cover flows that are critical in the Java implementation.


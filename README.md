# StepByStepTracking

> **Side effects shouldn't dictate your architecture.**

`StepByStepTracking` is a lightweight tracking utility designed with Clean Architecture in mind. It treats tracking as a **side effect** — not something that pollutes your domain models or flows. Instead of forcing tracking data through every layer, it uses a step-based context model to automatically associate values with events.

- ✅ No more passing tracking values through multiple layers.
- ✅ No need to modify your domain models just for analytics.
- ✅ Works seamlessly with SwiftUI and Composable UIs.

## 🌍 Global Properties

You can attach shared properties (e.g., `userID`) to all subsequent events, making them automatically included without being explicitly passed around.

```swift
tracker.setProperties(.properties(.userID), value: "USER_ID")
```

---

## 🧭 Step-Based Tracking

Each screen or logical state in your app can be mapped to a **tracking step**. This step holds contextual properties automatically inherited by all events triggered within that scope.

For example, when navigating to the `home` screen:

```swift
tracker.onStep(.steps(.home), properties: [
    .property(.properties(.screenName), "home")
])
```

Steps are identified by a unique `name/id`. Re-calling `onStep` with a previously used ID resets the step stack, simulating natural view hierarchies. Typically, you call `onStep` in `onAppear`:

```swift
struct HomeView: View {
    @Environment(\.tracker) var tracker: TrackingService

    var body: some View {
        VStack {
            ...
        }
        .onAppear {
            tracker.onStep(.steps(.home), properties: [
                .property(.properties(.screenName), "home")
            ])
        }
    }
}
```

---

## ⚡ Sending Events with Minimal Payload

Let’s say a user is **logged in** and on the **home screen**, and they tap a `Refresh` button:

```swift
Button("Refresh") {
    tracker.sendEvent(.events(.refresh))
}
```

The resulting event payload will automatically include:

- `event name`: `refresh`
- `userID`: `USER_ID`
- `screen`: `home`

**UIKit or Custom Step compatible**. Perfect for **Composable UI architectures** (e.g. SwiftUI), where passing props deeply can be cumbersome.

---

## ⏳ Deferred Properties

Sometimes, data retrieved from a network or database isn't relevant to business logic but is still useful for tracking.

For example, fetched posts:

```json
[
  { "id": 1, "name": "Post 1", "content": "Post 1 content", "campaignID": "c1" },
  { "id": 2, "name": "Post 2", "content": "Post 2 content", "campaignID": "c2" }
]
```

Converted to a domain model:

```swift
struct Post {
    let id: Int
    let name: String
}
```

You don’t need `campaignID` for business logic, but you want to track it.

Use `setDeferredProperties` right after data loading:

```swift
let values = items.compactMap { item -> TrackingElement? in
    TrackingElement(.init(name: String(item.id)), properties: [
        .property(.properties(.id), item.id),
        .property(.properties(.name), item.name),
        .property(.properties(.campaignID), item.campaignID)
    ])
}
tracker.setDeferredProperties(values)
```

When a user taps on a post, just trigger the event using its ID:

```swift
tracker.sendDeferredEvent(.events(.postSelected), byPropertiesID: id)
```

The full event payload will include:

- `event name`: `postSelected`
- `id`: `<selectedItem.id>`
- `name`: `<selectedItem.name>`
- `campaignID`: `<selectedItem.campaignID>`

---

### ✅ Summary

`StepByStepTracking` helps you:

- Keep tracking as a side effect
- Avoid modifying domain models
- Enable powerful contextual tracking without boilerplate
- Simplify SwiftUI/UIKit analytics

> **Architecture wins when side effects stay decoupled.**

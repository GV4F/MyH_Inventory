# MyH Solutions - Inventory and Project Management

A robust, industrial-grade mobile application designed to streamline inventory tracking and project management for construction operations. Built with a focus on traceability, security and high-performance UX.

## 🚀 The Mission

In the construction industry, tracking materials and "who moved what" is often a manual, error-prone process. This app was conceived to eliminate the "paper trail" and provide real-time accountability.

### Problems it Solves:
* **Lack of Traceability:** Automated logging of which user added or modified an item.

* **Inventory Mismanagement:** Real-time visibility of material levels across different sites.
* **Security Risks:** Implementation of Row Level Security (RLS) to ensure only authorized personnel can modify crititcal data.
* **Field Accessibility:** A specialized UI designed for high-glare environments (High Contrast Dark Mode) and ease of use on the go.

## 🛠️ Tech Stack

* **Frontend:** Flutter (Framework).
* **Backend and Auth:** Supabase (PostgreSQL and GoTrue).
* **Navigation:** GoRouter for state-aware routing.
* **Database Logic:** PL/pgSQL Triggers for automated profile management and data grounding.

## ✨ Key Features
* **Automated Indentify:** Every transaction is automatically stamped with the user's ID using SQL-level defaults (auth.uid()).
* **Dynamic Modals:** Detailed item views with asynchronous fetching of creator profiles.
* **State-Aware Navigation:** Integrated authentication listener that redirects users based on their session status.

## 🏗️ Architecture and Security
### Row Level Security (RLS)

Security is handled at the database level. Each table is protected by RLS policies.

### Database Triggers

The app utilizes a specialized SQL trigger that listens for new auth sigh-ups to automatically populate the public.profiles table, esuring the application remains in sync with Supabase.Auth.

``` sql
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

## 📖 Main Use Cases
1. **Material Check-in:** Log new shipments of cement, steel or tools.
2. **Usage Tracking:** Record when materials are moved to specific construction sectors.
3. **Audit Trails:** Use the "More Info" modal to see exactly who added a product and when.

## 🐺 Programmer Note

Finally i would like to thank my boss for giving me this opportunity, i didn't have prior experience developing a mobile applications 😅; in fact this is my first mobile app and the first one for a real company. Before this, I only developed web applications and some projects for my own use. This challenge has taught me a lot and, despite a few bugs 🪲, I have enjoyed it immensely. 🖤

### 🎯Project completed on Sunday, April 12, 2026 at 05:21 PM.
---
name: Aura Neumorphic
colors:
  surface: '#f2fbfc'
  surface-dim: '#d3dcdd'
  surface-bright: '#f2fbfc'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#ecf5f6'
  surface-container: '#e7f0f1'
  surface-container-high: '#e1eaeb'
  surface-container-highest: '#dbe4e5'
  on-surface: '#151d1e'
  on-surface-variant: '#414754'
  inverse-surface: '#293233'
  inverse-on-surface: '#e9f2f3'
  outline: '#727785'
  outline-variant: '#c1c6d6'
  surface-tint: '#005bc0'
  primary: '#0058bb'
  on-primary: '#ffffff'
  primary-container: '#0070ea'
  on-primary-container: '#fdfbff'
  inverse-primary: '#adc6ff'
  secondary: '#00668a'
  on-secondary: '#ffffff'
  secondary-container: '#8dd5fe'
  on-secondary-container: '#005d7e'
  tertiary: '#9e3e00'
  on-tertiary: '#ffffff'
  tertiary-container: '#c64f00'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a41'
  on-primary-fixed-variant: '#004493'
  secondary-fixed: '#c3e8ff'
  secondary-fixed-dim: '#87cff8'
  on-secondary-fixed: '#001e2c'
  on-secondary-fixed-variant: '#004c68'
  tertiary-fixed: '#ffdbcc'
  tertiary-fixed-dim: '#ffb695'
  on-tertiary-fixed: '#351000'
  on-tertiary-fixed-variant: '#7b2e00'
  background: '#f2fbfc'
  on-background: '#151d1e'
  surface-variant: '#dbe4e5'
  surface-bg: '#f2fbfc'
  shadow-dark: '#d1d9e6'
  shadow-light: '#ffffff'
  accent-green: '#22c55e'
  accent-orange: '#ea580c'
  accent-indigo: '#4f46e5'
  accent-purple: '#9333ea'
  status-error: '#ba1a1a'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 28px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-sm:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 8px
  gutter: 16px
  container-padding: 24px
  card-gap: 20px
  section-margin: 40px
---

## Brand & Style
Aura Home is a premium smart home management system that emphasizes comfort, soft technology, and tactile interaction. The brand personality is **sophisticated, serene, and approachable**.

The visual language is rooted in **Modern Neomorphism**. It avoids the harshness of flat design by using soft, extruded UI elements that appear to be molded from the background surface. This creates a physical, "squishy" feel that evokes high-end home automation hardware. The aesthetic is reinforced by a cool-toned, airy color palette and generous whitespace, resulting in a UI that feels light, breathable, and calm.

## Colors
The palette is dominated by a "Liquid Cyan" neutral (`#f2fbfc`), which serves as the base for all neumorphic effects. 

- **Primary:** A vibrant "Electric Blue" (`#0070ea`) used for active states, primary toggles, and focus indicators.
- **Surface & Shadows:** The neomorphic effect relies on a specific triad: the base surface (`#f2fbfc`), a light source shadow (`#ffffff`), and a soft depth shadow (`#d1d9e6`).
- **Functional Accents:** Low-opacity tinted backgrounds (e.g., `indigo-500/10`) are used behind iconography to provide category-specific "glows" without breaking the soft aesthetic.
- **Typography:** Deep charcoal (`#151d1e`) provides high legibility against the light background, while a muted slate (`#414754`) is used for secondary metadata.

## Typography
The system uses **Plus Jakarta Sans** for its friendly, modern geometric forms that complement the rounded UI. **Geist** is introduced for small labels and metadata to provide a technical, clean contrast that aids in information hierarchy.

- **Headlines:** Use heavy weights (700) with tight letter-spacing to create a strong visual anchor.
- **Labels:** Always uppercase with increased letter-spacing to distinguish section headers and small captions.
- **Body:** Uses a slightly heavier-than-normal weight (500) for "Large" body text to ensure it holds its own against the soft shadows of the containers.

## Layout & Spacing
The system follows a **Dynamic Padding** model centered on an 8px grid.

- **Margins:** Mobile screens use a 24px (3 units) side margin for the main container.
- **Grouping:** Related items are grouped into "Raised" cards. These cards use 20px (2.5 units) of vertical spacing between them.
- **Section Headers:** Section labels are indented 8px (1 unit) from the card edge to align visually with the text inside the containers.
- **Reflow:** On mobile, content is strictly single-column. For tablet/desktop, the central column remains max-width 512px (max-lg) to maintain the "handheld" feel of a remote control interface.

## Elevation & Depth
Depth is the primary communicator of hierarchy.

- **Raised (Neumorphic):** Applied to primary containers and buttons. Uses dual shadows: `8px 8px 16px #d1d9e6` (bottom-right) and `-8px -8px 16px #ffffff` (top-left). This makes the element appear to rise out of the background.
- **Sunken (Inner Shadow):** Applied to active states, input fields, or "off" states for certain controls. Uses `inset 4px 4px 8px #d1d9e6` and `inset -4px -4px 8px #ffffff`.
- **Glows:** Decorative icons use a `drop-shadow` with 50% opacity of their specific accent color to create a soft "lit from within" effect.
- **Floating Nav:** The bottom navigation bar uses a **Glassmorphic** approach with `backdrop-blur-xl` and a high-opacity white border to separate it from the scrolling content beneath.

## Shapes
The shape language is extremely rounded, favoring organic, pill-like forms.

- **Primary Containers:** 24px (3 units) corner radius (`rounded-3xl`) is the standard for cards and grouped lists.
- **Icons & Small Elements:** 12px (1.5 units) corner radius (`rounded-xl`) for icon backgrounds.
- **Navigation/Pills:** Full rounding (`rounded-full`) is reserved for the bottom navigation bar and active state highlights.
- **Image Assets:** Profile photos use a 16px (`rounded-2xl`) radius to fit the softer aesthetic.

## Components

- **Buttons & Cards:** Every interactable card should have a `scale-95` transition on press to provide tactile feedback. They use the "Raised" neumorphic style by default.
- **Toggle Switches:** Composed of a "Sunken" track and a "Raised" pill thumb. When active, the track transitions to the Primary Blue color with a soft outer glow.
- **Grouped Lists:** Use a single "Raised" container. Internal items are separated by a subtle `outline-variant` (`#c1c6d7`) divider. Individual rows have a light-white hover state.
- **Status Badges:** Small, pill-shaped indicators with high-contrast text and low-opacity backgrounds. Used for role identification (e.g., "Owner").
- **Bottom Navigation:** A floating dock style. The active state is indicated by a Primary Blue icon and a background "Glow" created by a blurred, low-opacity circle behind the button.
- **Iconography:** Material Symbols (Outlined). Icons are generally 24px, centered in 40px rounded-xl boxes with tinted backgrounds.
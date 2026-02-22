/// STEP 0: Pixel-perfect checklist for each screen.
/// We'll verify these 1:1 against Figma as we code.
class FigmaChecklist {
  // 1) Layout
  static const layout = [
    'All paddings/margins match Figma (every container)',
    'All sizes match Figma (buttons, inputs, cards, icons)',
    'All alignments match Figma (center/left/right, baseline, spacing)',
  ];

  // 2) Typography
  static const typography = [
    'Font family matches Figma',
    'Font sizes and weights match',
    'Line height matches',
    'Letter spacing matches (if used)',
  ];

  // 3) Colors
  static const colors = [
    'Exact hex values (including opacity)',
    'Borders/dividers match',
    'Disabled/secondary states match',
  ];

  // 4) Components
  static const components = [
    'Buttons: radius, height, padding, text style, shadow',
    'Inputs: border, radius, label/hint style, focus state',
    'Cards: radius, shadow, padding',
  ];

  // 5) Behavior (front-end only)
  static const behavior = [
    'Navigation transitions match prototype (push/modal/bottom sheet)',
    'Scrolling behavior matches (bouncing/clamping)',
    'Keyboard behavior matches (insets, bottom sheet resize)',
  ];
}

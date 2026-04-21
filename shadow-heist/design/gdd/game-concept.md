# Game Concept: VOID SLIP

*Created: 2026-04-21*
*Status: Draft*

---

## Elevator Pitch

> Bạn là một thực thể bóng tối phải luồn qua mê cung ánh sáng neon trong phòng lab bí mật để đánh cắp dữ liệu và thoát ra ngoài — tiếp xúc với ánh sáng đồng nghĩa với cái chết, nhưng chết nhanh và chơi lại nhanh là trái tim của trải nghiệm. Đây là stealth action 2D top-down, nơi mỗi dash hoàn hảo tạo ra cảm giác vô song, và mỗi cái chết là lời mời thử lại.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Stealth Action 2D / Movement Precision |
| **Platform** | Web (HTML5), via Godot 4 export |
| **Target Audience** | Hardcore gamers 16–30 tuổi, thích mastery và movement feel |
| **Player Count** | Single-player |
| **Session Length** | 10–30 phút |
| **Monetization** | Không (free / itch.io) |
| **Estimated Scope** | Small (3–4 tuần, solo dev) |
| **Comparable Titles** | Neon White, Hotline Miami, Hollow Knight |

---

## Core Fantasy

Bạn không phải là con người. Bạn là bóng tối — một thực thể được tạo ra từ sự vắng mặt của ánh sáng. Ánh sáng không chỉ nguy hiểm, nó xói mòn sự tồn tại của bạn. Cảm giác trượt qua khe hở giữa hai luồng sáng, chain dash trong 0.3 giây hoàn hảo, và đến được data node mà không để lại dấu vết — đó là đỉnh cao của control và mastery mà game này hứa hẹn.

Không có gì đánh bại cảm giác "suýt chết nhưng sống" — khoảnh khắc bạn grazes qua ánh sáng, nghe tiếng cảnh báo, nhưng vẫn kịp rút vào bóng tối. Game này sống ở khoảnh khắc đó.

---

## Unique Hook

Như **Neon White**, AND ALSO bạn không phải là người — bạn **là** bóng tối, và ánh sáng không chỉ là chướng ngại vật mà là kẻ thù vật lý xói mòn sự tồn tại của bạn theo nghĩa đen. Light2D physics làm cho detection trở nên trực quan tức thì — không cần UI indicator, không cần tutorial: sáng = chết, tối = sống.

---

## Visual Identity Anchor

**Tên hướng visual**: *Neon Void*

**One-line visual rule**: Nếu không tối, là sai. Ánh sáng là kẻ thù — về mặt gameplay lẫn aesthetics.

**3 nguyên tắc visual với design tests:**

1. **Background = near-black, không phải đen tuyền**
   Dùng deep navy (#0a0a1a) thay vì #000000 — tạo depth mà không mất contrast.
   *Design test*: "Nếu tắt toàn bộ light sources, người chơi có vẫn thấy được floor/wall geometry không? Nếu có → pass."

2. **Accent colors chỉ có 2: neon tím (#c084fc) và neon xanh cyan (#22d3ee)**
   Guards và báo động dùng tím. Data nodes và exit dùng xanh. Không màu nào khác trừ khi có lý do design.
   *Design test*: "Asset mới này có dùng màu ngoài palette không? Nếu có → đổi lại."

3. **Light sources tạo contrast drama, không tạo beauty**
   Ánh sáng trong game không đẹp — nó đáng sợ. Góc đổ bóng nhọn, không diffuse mềm.
   *Design test*: "Nhìn vào room này lần đầu, người chơi có ngay lập tức thấy đâu an toàn và đâu nguy hiểm không? Nếu không → redesign lighting."

**Color philosophy**: Bóng tối là home. Ánh sáng là death. Palette phải reinforce điều này ở mọi pixel.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Challenge** (mastery) | 1 | Dash timing, light avoidance, route optimization |
| **Sensation** (sensory pleasure) | 2 | Dash animation juice, screen shake khi near-miss, neon glow SFX |
| **Fantasy** (make-believe) | 3 | Player identity là "shadow entity" — không phải human |
| **Discovery** (secrets) | 4 | Hidden routes trong levels, data fragments bonus |
| **Narrative** | N/A | Tối giản — chỉ atmosphere, không có story dài |
| **Fellowship** | N/A | Single-player |
| **Expression** | N/A | Không có build variety — mastery là expression |
| **Submission** | N/A | Không phải relaxing game |

### Key Dynamics (Emergent player behaviors)

- Người chơi tự nhiên sẽ tìm "optimal route" qua mỗi room sau vài lần chết
- Người chơi sẽ bắt đầu đếm timing của light sources để chain dash
- Người chơi sẽ cố collect tất cả data fragments sau khi đã master safe route
- Người chơi sẽ share "clean run" videos vì movement đẹp mắt

### Core Mechanics (Systems we build)

1. **Dash/Slip Movement** — momentum-based dash với input buffer nhỏ, chain dash khi thực hiện liên tiếp
2. **Light Physics Detection** — Godot `Light2D` + `OccluderPolygon2D`; tiếp xúc ánh sáng = instant death
3. **Guard Patrol System** — guard di chuyển theo patrol path với light cone đi kèm
4. **Data Collection & Exit** — collect data nodes → activate exit portal
5. **Instant Respawn** — death → fade out 0.2s → respawn tại checkpoint trong cùng room, không có loading screen

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Competence** | Mỗi run cải thiện rõ rệt — ít chết hơn, nhanh hơn, route đẹp hơn | Core |
| **Autonomy** | Tự chọn route qua shadow zones, tự quyết định khi nào dash | Core |
| **Relatedness** | Kết nối với shadow entity qua visual vulnerability — body co lại khi gần ánh sáng | Supporting |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Achievers** — Hoàn thành level với 0 deaths, collect all data, beat time record
- [x] **Explorers** — Tìm hidden routes và secret data fragments
- [ ] **Socializers** — Không có social component
- [ ] **Killers/Competitors** — Không có PvP; leaderboard là stretch goal

### Flow State Design

- **Onboarding curve**: Level 1 = 1 stationary guard, 1 light beam. Học dash trong 30 giây. Không có tutorial text — learn by doing.
- **Difficulty scaling**: Số lượng light sources tăng, guard patrol speed tăng, data node placement khó hơn
- **Feedback clarity**: Screen shake + color flash khi near-miss; SFX riêng cho "safe dash" vs "danger dash"
- **Recovery from failure**: Chết → respawn trong < 0.5 giây. Không có death screen dài, không có punishment khác ngoài mất time

---

## Core Loop

### Moment-to-Moment (30 giây)
Quan sát room → identify shadow zones → tính timing của light sources → chain dash qua khoảng trống → grab data node → về exit portal. Bị lộ → instant death → instant respawn → thử lại.

*Why it's intrinsically satisfying*: Dash animation + screen shake + near-miss SFX tạo micro-reward mỗi vài giây. Timing precision tạo muscle memory. Không có downtime.

### Short-Term (5–15 phút)
Hoàn thành 1 room → unlock cửa sang room kế. Mỗi room có layout ánh sáng độc lập. Collecting tất cả data fragments là bonus challenge (không bắt buộc để advance). "One more room" = natural hook.

### Session-Level (20–40 phút)
Hoàn thành 1 level (3–5 rooms liên tiếp) với escape sequence cuối (ánh sáng trigger alarm, chạy ra cửa). Score: time + số lần chết + data % collected. Người chơi nghĩ "tôi có thể làm sạch hơn lần sau."

### Long-Term Progression
Không có stat progression — **knowledge progression thuần túy**. Người chơi giỏi hơn vì *họ* học, không phải vì character mạnh hơn. Giống Dark Souls/Hollow Knight — khi beat level, bạn *cảm thấy* mình giỏi hơn.

### Retention Hooks
- **Mastery**: "Tôi chết 12 lần ở room 3 — lần này tôi sẽ qua không chết"
- **Curiosity**: "Room tiếp theo có gì?"
- **Investment**: Score/time cá nhân best — không muốn "lãng phí" progress
- **Social**: "Nhìn cái chain dash này" — shareable moments

---

## Game Pillars

### Pillar 1: MOVEMENT IS EXPRESSION
Mọi hành động của player phải có feel. Dash không chỉ là di chuyển — nó là ngôn ngữ của nhân vật, và người chơi phải cảm nhận được sự khác biệt giữa một dash tốt và một dash tệ.

*Design test*: "Tính năng mới này có làm movement phong phú hơn hoặc phức tạp hơn theo nghĩa tốt không? Nếu không — cắt."

### Pillar 2: DEATH IS INVITATION, NOT PUNISHMENT
Chết phải nhanh, sạch, và immediate invite thử lại. Mọi friction giữa death và retry là kẻ thù của game này.

*Design test*: "Sau khi chết, người chơi cảm thấy muốn thử lại ngay hay muốn tắt game? Nếu muốn tắt — fix."

### Pillar 3: LIGHT IS THE ENEMY, SHADOW IS HOME
Ánh sáng = nguy hiểm vật lý. Bóng tối = safe zone. Binary này phải được reinforced ở mọi level của design — mechanics, visuals, audio.

*Design test*: "Mechanic này có làm mờ hoặc phức tạp hóa ranh giới sáng/tối không? Nếu có — cân nhắc lại."

### Pillar 4: MASTERY OVER POWER
Không có stat upgrades, không có loot, không có power scaling. Người chơi giỏi hơn vì skill thực sự tăng — không phải vì số to hơn.

*Design test*: "Người chơi có thể bypass challenge này bằng grinding/upgrades không? Nếu có — redesign."

### Anti-Pillars (What This Game Is NOT)

- **NOT RPG/Loot game**: Không có EXP, inventory, hay build variety — sẽ làm loãng mastery focus và inflate scope
- **NOT story-heavy**: Không có dialogue dài, cutscene nhiều — sẽ break flow state và không phù hợp timeline
- **NOT slow-paced stealth puzzle**: Không phải lồng từng bước như Hitman — movement fluidity là ưu tiên hàng đầu
- **NOT roguelite**: Levels cố định, không random generation — dễ design tốt hơn và phù hợp timeline vài tuần

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| **Neon White** | Dash-based movement, neon aesthetic, speedrun appeal, "one more run" | Đây là stealth, không phải shooter — không có weapons, shadow là vũ khí | Validates: dash + neon + mastery = audience tồn tại |
| **Hollow Knight** | Tight 2D controls, feel tốt, dark atmospheric world, death-and-retry cảm giác fair | Top-down thay vì side-scroller, không có narrative depth | Validates: precise 2D movement + dark aesthetic = cult hit potential |
| **Hotline Miami** | "Die instantly, retry instantly" loop, top-down 2D, high-tension, stylized violence | Stealth thay vì action — không có combat, tránh là cơ chế duy nhất | Validates: instant death + instant retry = addictive, không frustrating |

**Non-game inspirations**:
- Phim *Inception* (2010): Thâm nhập vào một hệ thống không thuộc về bạn, căng thẳng từng bước
- Âm nhạc: Synthwave/darksynth — The Algorithm, Carpenter Brut — tạo atmosphere neon dark
- Visual art: Cyberpunk noir pixel art — tối màu tuyệt đối với điểm sáng neon

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 16–30 |
| **Gaming experience** | Hardcore — chơi Souls, Hollow Knight, platformers precision |
| **Time availability** | 20–60 phút mỗi session, chơi nhiều session ngắn |
| **Platform preference** | PC + browser (itch.io, Newgrounds) |
| **Current games they play** | Hollow Knight, Neon White, Celeste, hoặc các game indie action 2D |
| **What they're looking for** | Movement feel đẹp, challenge fair, cảm giác "tôi làm được" sau nhiều lần thất bại |
| **What would turn them away** | Slow tutorial, loading screen dài sau khi chết, progress gating qua grind |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Engine** | Godot 4, GDScript, HTML5 export |
| **Key Technical Challenges** | Light2D performance trên HTML5; dash feel calibration (momentum, cancel frames); guard patrol AI |
| **Art Style** | Pixel art 2D top-down — dark background, neon accent tím (#c084fc) và cyan (#22d3ee) |
| **Art Pipeline Complexity** | Medium — pixel art custom 2D, animation dash cần polish |
| **Audio Needs** | Moderate — SFX cho dash/near-miss/death quan trọng; background synthwave ambient |
| **Networking** | None |
| **Content Volume** | MVP: 1 level, 3 rooms. Ship: 3 levels, 9–12 rooms. Full vision: 5 levels |
| **Procedural Systems** | Không — fixed hand-crafted levels |

---

## Risks and Open Questions

### Design Risks
- **Near-miss feel khó calibrate**: Khoảng "grazing zone" quá rộng → frustrustating; quá hẹp → không có drama
- **Level design phụ thuộc nhiều vào iteration**: First-time dev chưa có intuition cho stealth level design tốt

### Technical Risks
- **Light2D HTML5 performance**: Shadow rendering nặng trong browser, cần test sớm với nhiều light sources
- **Dash feel**: Momentum-based movement cần nhiều iteration — có thể mất 30-50% thời gian dev cho cảm giác này đúng

### Market Risks
- **Segment nhỏ nhưng vocal**: Hardcore stealth/movement fans không đông nhưng rất passionate — phù hợp cho first game
- **Competition từ Neon White**: Đã làm "neon dash mastery" rất tốt — VOID SLIP cần differentiate rõ ở stealth element

### Scope Risks
- **Timeline vài tuần rất tight**: Nếu dash feel mất nhiều thời gian → art/level design bị cắt
- **Pixel art + animation**: Custom pixel animation có thể underestimated về thời gian

### Open Questions
- **Câu hỏi 1**: Light2D có đủ performant trên HTML5 với 5+ light sources không? → Prototype room đơn giản trong Godot và test trên browser ngay tuần đầu
- **Câu hỏi 2**: Dash feel có đạt được cảm giác "Fluid & Fast" trong vài ngày hay cần nhiều hơn? → Prototype input system trước mọi thứ khác

---

## MVP Definition

**Core hypothesis**: *Dash-based movement + light physics detection tạo ra vòng lặp "near-miss → chết → thử lại" đủ addictive để người chơi muốn chơi nhiều lần.*

**Required for MVP**:
1. Dash mechanic hoạt động đúng feel (momentum + chain + cancel)
2. Light2D detection: tiếp xúc ánh sáng = instant death
3. 1 level với 1 room, 2–3 guard stationary với light cones
4. Data node + exit portal (collect → exit để win)
5. Instant respawn (< 0.5s) tại room start
6. Playable trên browser (HTML5 export)

**Explicitly NOT in MVP**:
- Story, dialogue, narrative context
- Guard patrol movement (chỉ stationary trước)
- Score/leaderboard system
- Sound effects và music
- Multiple levels
- Pixel art polish (placeholder shapes OK)

### Scope Tiers

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | 1 level, 1 room | Dash + light detection + instant respawn | 1–2 tuần |
| **Vertical Slice** | 1 level, 3 rooms | Patrol guards + data collection + score screen | 2–3 tuần |
| **Ship** | 3 levels, 9 rooms | SFX + pixel art polish + guard AI variety | 3–4 tuần |
| **Full Vision** | 5 levels, 15 rooms | Combo animations + ambient narrative + leaderboard | 2–3 tháng |

---

## Next Steps

- [ ] Run `/setup-engine` để cấu hình Godot 4 và populate version-aware reference docs
- [ ] Run `/art-bible` để tạo visual identity specification (dựa trên Visual Identity Anchor: *Neon Void*)
- [ ] Run `/design-review design/gdd/game-concept.md` để validate concept completeness
- [ ] Run `/map-systems` để decompose VOID SLIP thành các hệ thống riêng biệt (dash, detection, guard AI, level)
- [ ] Run `/design-system` cho từng hệ thống MVP
- [ ] Run `/create-architecture` để produce master architecture blueprint
- [ ] Run `/prototype dash-movement` để validate dash feel trước khi đi sâu vào level design
- [ ] Run `/playtest-report` sau prototype để validate core hypothesis
- [ ] Run `/gate-check` trước khi chuyển sang production
- [ ] Run `/sprint-plan new` để lên kế hoạch sprint đầu tiên

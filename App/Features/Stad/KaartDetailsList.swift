import SwiftUI

/// Every detail hidden in the city, with its word. World units; the drawings live in
/// KaartDetailArt*.swift. Most show only at close zoom; the tour boat and the swans also at
/// normal zoom. Kept clear of the places' tap areas, on the right ground (boats on water,
/// stands on streets and squares).
nonisolated enum KaartDetails {
    static let all: [KaartDetail] = cats + water + town + country

    private static let open: [GevelSeason] = [.lente, .zomer, .herfst]
    private static let warm: [GevelSeason] = [.lente, .zomer]

    // MARK: Cats

    private static let cats: [KaartDetail] = [
        KaartDetail(
            id: "kat-brug", kind: .kat, nl: "kat", article: .de, en: "cat",
            point: CGPoint(x: 509, y: 519), size: CGSize(width: 10, height: 9)
        ),
        KaartDetail(
            id: "poes-fiets", kind: .poes, nl: "poes", article: .de, en: "cat, kitty",
            point: CGPoint(x: 158, y: 200), size: CGSize(width: 20, height: 15)
        ),
        KaartDetail(
            id: "poezenboot", kind: .poezenboot, nl: "woonboot", article: .de, en: "houseboat (the cat boat)",
            point: CGPoint(x: 531, y: 385), size: CGSize(width: 28, height: 14)
        ),
        KaartDetail(
            id: "katje-wol", kind: .katje, nl: "katje", article: .het, en: "kitten",
            point: CGPoint(x: 484, y: 298), size: CGSize(width: 12, height: 8)
        ),
    ]

    // MARK: On the water

    private static let water: [KaartDetail] = [
        KaartDetail(
            id: "eenden-prinsengracht", kind: .eend, nl: "eend", article: .de, en: "duck",
            point: KaartMapPaths.p(570, 64), size: CGSize(width: 23, height: 7),
            motion: .canal(radius: 570, from: 64, to: 72, period: 50), seasons: open, nightToo: false
        ),
        KaartDetail(
            id: "rondvaartboot", kind: .rondvaartboot, nl: "rondvaartboot", article: .de, en: "canal tour boat",
            point: KaartMapPaths.p(570, 86.5), size: CGSize(width: 40, height: 11.5), minZoom: 1,
            motion: .canal(radius: 570, from: 86.5, to: 93.5, period: 44), seasons: open
        ),
        KaartDetail(
            id: "sloep-vrienden", kind: .sloep, nl: "sloep", article: .de, en: "small open boat",
            point: KaartMapPaths.p(570, 108), size: CGSize(width: 22, height: 10),
            motion: .canal(radius: 570, from: 108, to: 116, period: 36), seasons: open, nightToo: false
        ),
        KaartDetail(
            id: "meerkoet-herengracht", kind: .meerkoet, nl: "nest", article: .het, en: "nest (a coot's nest)",
            point: CGPoint(x: 292, y: 307), size: CGSize(width: 14, height: 9), seasons: warm
        ),
        KaartDetail(
            id: "reiger-haringkar", kind: .reiger, nl: "reiger", article: .de, en: "heron",
            point: CGPoint(x: 626, y: 52), size: CGSize(width: 11, height: 17)
        ),
        KaartDetail(
            id: "roeiboot-rivier", kind: .roeiboot, nl: "roeiboot", article: .de, en: "rowing boat",
            point: CGPoint(x: 670, y: 41), size: CGSize(width: 18, height: 8.5),
            motion: .path([CGPoint(x: 670, y: 41), CGPoint(x: 770, y: 39)], period: 40), seasons: open, nightToo: false
        ),
        KaartDetail(
            id: "zwanen-meer", kind: .zwaan, nl: "zwaan", article: .de, en: "swan",
            point: CGPoint(x: 840, y: 1138), size: CGSize(width: 26, height: 15), minZoom: 1,
            motion: .path([CGPoint(x: 840, y: 1138), CGPoint(x: 930, y: 1146)], period: 60), seasons: open
        ),
        KaartDetail(
            id: "waterfiets-meer", kind: .waterfiets, nl: "waterfiets", article: .de, en: "pedal boat",
            point: CGPoint(x: 300, y: 1135), size: CGSize(width: 14, height: 9),
            motion: .path([CGPoint(x: 300, y: 1135), CGPoint(x: 420, y: 1128)], period: 60), seasons: warm, nightToo: false
        ),
    ]

    // MARK: In town

    private static let town: [KaartDetail] = [
        KaartDetail(
            id: "draaiorgel-station", kind: .draaiorgel, nl: "draaiorgel", article: .het, en: "street organ",
            point: CGPoint(x: 392, y: 64), size: CGSize(width: 26, height: 21), nightToo: false
        ),
        KaartDetail(
            id: "paaltjes-station", kind: .paaltje, nl: "paaltje", article: .het, en: "bollard (little post)",
            point: CGPoint(x: 446, y: 86), size: CGSize(width: 22, height: 8)
        ),
        KaartDetail(
            id: "duiven-station", kind: .duif, nl: "duif", article: .de, en: "pigeon",
            point: CGPoint(x: 562, y: 67), size: CGSize(width: 24, height: 10), nightToo: false
        ),
        KaartDetail(
            id: "haringkar", kind: .haring, nl: "haring", article: .de, en: "herring",
            point: CGPoint(x: 600, y: 64), size: CGSize(width: 23, height: 19), nightToo: false
        ),
        KaartDetail(
            id: "stroopwafelkraam", kind: .stroopwafel, nl: "stroopwafel", article: .de, en: "syrup waffle",
            point: CGPoint(x: 291, y: 158), size: CGSize(width: 20, height: 20), nightToo: false
        ),
        KaartDetail(
            id: "bloemenfiets-brug", kind: .bloemenfiets, nl: "bloem", article: .de, en: "flower",
            point: CGPoint(x: 774, y: 185), size: CGSize(width: 20, height: 14)
        ),
        KaartDetail(
            id: "oliebollenkraam", kind: .oliebol, nl: "oliebol", article: .de, en: "Dutch doughnut",
            point: CGPoint(x: 842, y: 200), size: CGSize(width: 22, height: 18), seasons: [.winter], nightToo: false
        ),
        KaartDetail(
            id: "bloemenmarkt", kind: .tulp, nl: "tulp", article: .de, en: "tulip",
            point: CGPoint(x: 698, y: 302), size: CGSize(width: 20, height: 13), nightToo: false
        ),
        KaartDetail(
            id: "frietkraam", kind: .friet, nl: "friet", article: .de, en: "fries",
            point: CGPoint(x: 214, y: 478), size: CGSize(width: 18, height: 23), nightToo: false
        ),
        KaartDetail(
            id: "hond-plein", kind: .hond, nl: "hond", article: .de, en: "dog",
            point: CGPoint(x: 808, y: 502), size: CGSize(width: 11, height: 9), nightToo: false
        ),
        KaartDetail(
            id: "visser-prinsengracht", kind: .hengel, nl: "hengel", article: .de, en: "fishing rod",
            point: CGPoint(x: 943, y: 442), size: CGSize(width: 15, height: 12), seasons: open, nightToo: false
        ),
        KaartDetail(
            id: "bakfiets", kind: .bakfiets, nl: "bakfiets", article: .de, en: "cargo bike",
            point: KaartMapPaths.p(635, 66), size: CGSize(width: 24, height: 15),
            motion: .canal(radius: 635, from: 66, to: 75, period: 34), nightToo: false
        ),
    ]

    // MARK: Park, countryside and beach

    private static let country: [KaartDetail] = [
        KaartDetail(
            id: "paddenstoelen-park", kind: .paddenstoel, nl: "paddenstoel", article: .de, en: "mushroom",
            point: CGPoint(x: 160, y: 318), size: CGSize(width: 11, height: 8.5), seasons: [.herfst]
        ),
        KaartDetail(
            id: "egel-park", kind: .egel, nl: "egel", article: .de, en: "hedgehog",
            point: CGPoint(x: 236, y: 396), size: CGSize(width: 10, height: 6.5),
            motion: .path([CGPoint(x: 236, y: 396), CGPoint(x: 262, y: 392)], period: 24), seasons: [.herfst]
        ),
        KaartDetail(
            id: "sneeuwman-park", kind: .sneeuwman, nl: "sneeuwman", article: .de, en: "snowman",
            point: CGPoint(x: 262, y: 384), size: CGSize(width: 10, height: 14), seasons: [.winter]
        ),
        KaartDetail(
            id: "ganzen-wei", kind: .gans, nl: "gans", article: .de, en: "goose",
            point: CGPoint(x: 100, y: 776), size: CGSize(width: 26, height: 14),
            motion: .path([CGPoint(x: 100, y: 776), CGPoint(x: 196, y: 764)], period: 70), nightToo: false
        ),
        KaartDetail(
            id: "luchtballon-wei", kind: .luchtballon, nl: "luchtballon", article: .de, en: "hot-air balloon",
            point: CGPoint(x: 60, y: 738), size: CGSize(width: 18, height: 25),
            motion: .path([CGPoint(x: 60, y: 738), CGPoint(x: 170, y: 730)], period: 90), seasons: open, nightToo: false
        ),
        KaartDetail(
            id: "konijn-wei", kind: .konijn, nl: "konijn", article: .het, en: "rabbit",
            point: CGPoint(x: 60, y: 840), size: CGSize(width: 11, height: 10)
        ),
        KaartDetail(
            id: "kippen-boerderij", kind: .kip, nl: "kip", article: .de, en: "chicken",
            point: CGPoint(x: 960, y: 758), size: CGSize(width: 17, height: 10), nightToo: false
        ),
        KaartDetail(
            id: "kaas-boerderij", kind: .kaas, nl: "kaas", article: .de, en: "cheese",
            point: CGPoint(x: 814, y: 772), size: CGSize(width: 17, height: 14), nightToo: false
        ),
        KaartDetail(
            id: "ooievaar-polder", kind: .ooievaar, nl: "ooievaar", article: .de, en: "stork",
            point: CGPoint(x: 868, y: 904), size: CGSize(width: 14, height: 27), seasons: warm
        ),
        KaartDetail(
            id: "trekker-landweg", kind: .trekker, nl: "trekker", article: .de, en: "tractor",
            point: CGPoint(x: 548, y: 828), size: CGSize(width: 22, height: 16),
            motion: .path([CGPoint(x: 548, y: 828), CGPoint(x: 628, y: 815)], period: 40), seasons: open, nightToo: false
        ),
        KaartDetail(
            id: "lammetjes-dijk", kind: .lam, nl: "lam", article: .het, en: "lamb",
            point: CGPoint(x: 565, y: 1080), size: CGSize(width: 17, height: 10), seasons: [.lente]
        ),
        KaartDetail(
            id: "ligstoelen-strand", kind: .ligstoel, nl: "ligstoel", article: .de, en: "sun lounger",
            point: CGPoint(x: 436, y: 1094), size: CGSize(width: 21, height: 11), seasons: [.zomer], nightToo: false
        ),
        KaartDetail(
            id: "zandkasteel-strand", kind: .zandkasteel, nl: "zandkasteel", article: .het, en: "sandcastle",
            point: CGPoint(x: 378, y: 1092), size: CGSize(width: 15, height: 11), seasons: [.zomer]
        ),
        KaartDetail(
            id: "vlieger-strand", kind: .vlieger, nl: "vlieger", article: .de, en: "kite",
            point: CGPoint(x: 480, y: 1050), size: CGSize(width: 18, height: 28), seasons: open, nightToo: false
        ),
        KaartDetail(
            id: "ijscokar-strand", kind: .ijsje, nl: "ijsje", article: .het, en: "ice cream",
            point: CGPoint(x: 528, y: 1066), size: CGSize(width: 17, height: 18), seasons: warm, nightToo: false
        ),
    ]
}

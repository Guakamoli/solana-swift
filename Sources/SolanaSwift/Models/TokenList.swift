import Foundation

struct TokensList: Codable {
    let name: String
    let logoURI: String
    let keywords: [String]
    let tags: [String: TokenTag]
    let timestamp: String
    var tokens: [Token]
}

public struct TokenTag: Hashable, Codable {
    public var name: String
    public var description: String
}

public enum WrappingToken: String {
    case sollet, wormhole
}

public struct Token: Hashable, Codable {
    public init(
        _tags: [String]?,
        chainId: Int,
        address: String,
        symbol: String,
        name: String,
        decimals: Decimals,
        logoURI: String?,
        tags: [TokenTag] = [],
        extensions: TokenExtensions?,
        isNative: Bool = false
    ) {
        self._tags = _tags
        self.chainId = chainId
        self.address = address
        self.symbol = symbol
        self.name = name
        self.decimals = decimals
        self.logoURI = logoURI
        self.tags = tags
        self.extensions = extensions
        self.isNative = isNative
    }

    let _tags: [String]?

    public let chainId: Int
    public let address: String
    public let symbol: String
    public let name: String
    public let decimals: Decimals
    public let logoURI: String?
    public var tags: [TokenTag] = []
    public let extensions: TokenExtensions?
    public private(set) var isNative = false

    enum CodingKeys: String, CodingKey {
        case chainId, address, symbol, name, decimals, logoURI, extensions, _tags = "tags"
    }

    public static func unsupported(
        mint: String?,
        decimals: Decimals = 0,
        symbol: String = ""
    ) -> Token {
        Token(
            _tags: [],
            chainId: 101,
            address: mint ?? "<undefined>",
            symbol: symbol,
            name: mint ?? "<undefined>",
            decimals: decimals,
            logoURI: nil,
            tags: [],
            extensions: nil
        )
    }

    public static var nativeSolana: Self {
        .init(
            _tags: [],
            chainId: 101,
            address: "So11111111111111111111111111111111111111112",
            symbol: "SOL",
            name: "Solana",
            decimals: 9,
            logoURI: "https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/So11111111111111111111111111111111111111112/logo.png",
            tags: [],
            extensions: TokenExtensions(coingeckoId: "solana"),
            isNative: true
        )
    }

    public static var renBTC: Self {
        .init(
            _tags: nil,
            chainId: 101,
            address: PublicKey.renBTCMint.base58EncodedString,
            symbol: "renBTC",
            name: "renBTC",
            decimals: 8,
            logoURI: "https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/CDJWUqTcYTVAKXAVXoQZFes5JUFc7owSeq7eMQcDSbo5/logo.png",
            extensions: .init(
                website: "https://renproject.io/",
                serumV3Usdc: "74Ciu5yRzhe8TFTHvQuEVbFZJrbnCMRoohBK33NNiPtv",
                coingeckoId: "renbtc"
            )
        )
    }
    
    public static var usdc: Self {
        .init(
            _tags: nil,
            chainId: 101,
            address: PublicKey.usdcMint.base58EncodedString,
            symbol: "USDC",
            name: "USDC",
            decimals: 8,
            logoURI: "https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v/logo.png",
            extensions: .init(coingeckoId: "usd-coin")
        )
    }

    public var wrappedBy: WrappingToken? {
        if tags.contains(where: { $0.name == "wrapped-sollet" }) {
            return .sollet
        }

        if tags.contains(where: { $0.name == "wrapped" }),
           tags.contains(where: { $0.name == "wormhole" })
        {
            return .wormhole
        }

        return nil
    }

    public var isLiquidity: Bool {
        tags.contains(where: { $0.name == "lp-token" })
    }

    public var isUndefined: Bool {
        symbol.isEmpty
    }

    public var isNativeSOL: Bool {
        symbol == "SOL" && isNative
    }

    public var isRenBTC: Bool {
        address == PublicKey.renBTCMint.base58EncodedString ||
            address == PublicKey.renBTCMintDevnet.base58EncodedString
    }
}

public struct TokenExtensions: Hashable, Codable {
    public let website: String?
    public let bridgeContract: String?
    public let assetContract: String?
    public let address: String?
    public let explorer: String?
    public let twitter: String?
    public let github: String?
    public let medium: String?
    public let tgann: String?
    public let tggroup: String?
    public let discord: String?
    public let serumV3Usdt: String?
    public let serumV3Usdc: String?
    public let coingeckoId: String?
    public let imageUrl: String?
    public let description: String?

    public init(
        website: String? = nil,
        bridgeContract: String? = nil,
        assetContract: String? = nil,
        address: String? = nil,
        explorer: String? = nil,
        twitter: String? = nil,
        github: String? = nil,
        medium: String? = nil,
        tgann: String? = nil,
        tggroup: String? = nil,
        discord: String? = nil,
        serumV3Usdt: String? = nil,
        serumV3Usdc: String? = nil,
        coingeckoId: String?,
        imageUrl: String? = nil,
        description: String? = nil
    ) {
        self.website = website
        self.bridgeContract = bridgeContract
        self.assetContract = assetContract
        self.address = address
        self.explorer = explorer
        self.twitter = twitter
        self.github = github
        self.medium = medium
        self.tgann = tgann
        self.tggroup = tggroup
        self.discord = discord
        self.serumV3Usdt = serumV3Usdt
        self.serumV3Usdc = serumV3Usdc
        self.coingeckoId = coingeckoId
        self.imageUrl = imageUrl
        self.description = description
    }
}

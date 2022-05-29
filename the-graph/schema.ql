type Pair @entity {
  # pair address
  id: ID!

  # mirrored from the smart contract
  token0: Token!
  token1: Token!
  reserve0: BigDecimal!
  reserve1: BigDecimal!
  totalSupply: BigDecimal!
  ...
}

type Token @entity {
  # token address
  id: ID!

  # mirrored from the smart contract
  symbol: String!
  name: String!
  decimals: BigInt!

  # used for other stats like marketcap
  totalSupply: BigInt!

  # token specific volume
  tradeVolume: BigDecimal!
  tradeVolumeUSD: BigDecimal!
  untrackedVolumeUSD: BigDecimal!
  ...
}
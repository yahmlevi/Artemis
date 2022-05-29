export function handleDeposit(event: Deposit): void {
    // Entities can be loaded from the store using a string ID; this ID
    // needs to be unique across all entities of the same type
  
    // //event params
    let fromToken = event.params.fromToken;
    let destToken = event.params.destToken;
    let account = event.params.user;
    let depositAmount = event.params.amount;
    let userGas = event.params.userGas;
  
    if(depositAmount == BigInt.fromI32(0) && userGas == BigInt.fromI32(0)){
      return
    }
  
    //transaction data
    let txnHash = event.transaction.hash;
    let blockIndex = event.transaction.index
    let blockNumber = event.block.number
  
    // Entities only exist after they have been saved to the store;
    // `null` checks allow to create entities on demand
    // create new GroupData if the pair doesn't exist
  
    let groupSwap = GroupSwap.bind(Address.fromString("0x5101feD546FacccD309A77Ad755170f8fBf1E81D"))
    let groupId = groupSwap.getGroup(fromToken, destToken)
  
    //GroupData
    let groupEntity = GroupOrder.load(groupId.toHex())
  
    if (!groupEntity) {
      groupEntity = new GroupOrder(groupId.toHex())
      groupEntity.groupAmount = BigInt.fromI32(0)
      groupEntity.groupWei = BigInt.fromI32(0)
      let orderTxnHashes = new Array<Bytes>(0)
      orderTxnHashes.push(txnHash)
      groupEntity.orderTxnHashes = orderTxnHashes
    }
    else{
      let orderTxnHashes = groupEntity.orderTxnHashes
      orderTxnHashes.push(txnHash)
      groupEntity.orderTxnHashes = orderTxnHashes
    }
    
    groupEntity.groupAmount = groupEntity.groupAmount.plus(depositAmount)
    groupEntity.groupWei = groupEntity.groupWei.plus(userGas)
    groupEntity.fromToken = fromToken
    groupEntity.destToken = destToken
  
    //save groupEntity
    groupEntity.save()
  
    // OrderData
    let orderEntity = new Order(txnHash.toHex())
    orderEntity.account         = account
    orderEntity.status          = OrderStatus.get("OPEN")
    orderEntity.groupId         = groupId
    orderEntity.fromToken       = fromToken
    orderEntity.destToken       = destToken
    orderEntity.fromAmount      = depositAmount
    orderEntity.destAmount      = BigInt.fromI32(0)
    orderEntity.weiAdded        = userGas
    orderEntity.weiReturn       = BigInt.fromI32(0)
    orderEntity.depstTxnHash    = txnHash
    orderEntity.depstAmount     = depositAmount
    orderEntity.depstBlock      = event.block.number
    orderEntity.depstIndex      = event.transaction.index
    orderEntity.canclTxnHashes  = new Array<Bytes>()
    orderEntity.canclAmount     = BigInt.fromI32(0)
    orderEntity.wthdrwTxnHashes = new Array<Bytes>()
    orderEntity.wthdrwAmount    = BigInt.fromI32(0)
    orderEntity.save()
  }
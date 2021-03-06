{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE LambdaCase       #-}
{-# LANGUAGE TypeApplications #-}

module Test.Spec.Ed25519Bip44 (spec) where

import           Universum

import           Pos.Crypto (PublicKey)

import           Cardano.Wallet.Kernel.Ed25519Bip44 (deriveLvl3PublicKey)

import           Test.Hspec (Spec, describe, it)
import           Test.Pos.Core.Arbitrary ()
import           Test.QuickCheck (Property, property)

-- | It proves that we cannot derive address public key
-- if address index is too big.
prop_cannotDerivelvl3PublicKeyForBigIx
    :: PublicKey
    -> Word32
    -> Property
prop_cannotDerivelvl3PublicKeyForBigIx accountPublicKey addressIx = property $
    if addressIx >= maxIx
        then isNothing result
        else isJust result
  where
    result = deriveLvl3PublicKey accountPublicKey addressIx
    -- This is maximum value for soft derivation (only soft derivation
    -- is allowed to derive public key from public key).
    maxIx = 0x8000000

spec :: Spec
spec = describe "Ed25519Bip44" $ do
    it "Derivation fails if address index is too big" $
        property prop_cannotDerivelvl3PublicKeyForBigIx

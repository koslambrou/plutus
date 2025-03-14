\begin{code}
{-# OPTIONS --rewriting #-}

module Algorithmic.Erasure.Reduction where
\end{code}

\begin{code}
open import Function

open import Utils
open import Type
open import Type.BetaNormal
open import Algorithmic as A
import Algorithmic.Reduction as A
import Algorithmic.RenamingSubstitution as A
open import Algorithmic.Erasure
open import Algorithmic.Erasure.RenamingSubstitution
import Untyped.Reduction as U
import Untyped.RenamingSubstitution as U
open import Builtin
open import Builtin.Constant.Type
open import Builtin.Constant.Term Ctx⋆ Kind * _⊢Nf⋆_ con
open import Untyped
open import Type.BetaNBE.RenamingSubstitution
open import Data.Sum
open import Relation.Binary.PropositionalEquality hiding ([_])
open import Data.List using (List;[];_∷_)
open import Data.Vec hiding (map; [_])
open import Data.Product hiding (map) renaming (_,_ to _,,_)
open import Data.Unit hiding (_≤_; _≤?_; _≟_)
import Utils as Util
open import Relation.Nullary
open import Data.Nat hiding (_<_; _≤?_; _^_; _+_; _≟_; _*_)
open import Data.Integer hiding (suc)
open import Data.Fin using (suc)
import Data.Bool as B
\end{code}

\begin{code}
eraseCtx : ∀{Φ}(Γ : Ctx Φ) → Bwd U.Label
eraseCtx ∅        = []
eraseCtx (Γ ,⋆ J) = eraseCtx Γ :< U.Type
eraseCtx (Γ , A)  = eraseCtx Γ :< U.Term

erase≤C' : ∀{Φ Φ'}{Γ : Ctx Φ}{Γ' : Ctx Φ'} → Γ A.≤C' Γ' → eraseCtx Γ U.≤L eraseCtx Γ'
erase≤C' A.base      = U.base
erase≤C' (A.skip⋆ p) = U.skipType (erase≤C' p)
erase≤C' (A.skip p)  = U.skipTerm (erase≤C' p)

-- there could be a simpler version of this without p and q...
erase-arity-lem : ∀ b {Φ}{Γ}(p : proj₁ (sig b) ≡ Φ)(q : subst Ctx p (proj₁ (proj₂ (sig b))) ≡ Γ) → eraseCtx Γ ≡ U.arity b
erase-arity-lem addInteger refl refl = refl
erase-arity-lem subtractInteger refl refl = refl
erase-arity-lem multiplyInteger refl refl = refl
erase-arity-lem divideInteger refl refl = refl
erase-arity-lem quotientInteger refl refl = refl
erase-arity-lem remainderInteger refl refl = refl
erase-arity-lem modInteger refl refl = refl
erase-arity-lem lessThanInteger refl refl = refl
erase-arity-lem lessThanEqualsInteger refl refl = refl
erase-arity-lem equalsInteger refl refl = refl
erase-arity-lem appendByteString refl refl = refl
erase-arity-lem lessThanByteString refl refl = refl
erase-arity-lem lessThanEqualsByteString refl refl = refl
erase-arity-lem sha2-256 refl refl = refl
erase-arity-lem sha3-256 refl refl = refl
erase-arity-lem verifyEd25519Signature refl refl = refl
erase-arity-lem verifyEcdsaSecp256k1Signature refl refl = refl
erase-arity-lem verifySchnorrSecp256k1Signature refl refl = refl
erase-arity-lem equalsByteString refl refl = refl
erase-arity-lem ifThenElse refl refl = refl
erase-arity-lem appendString refl refl = refl
erase-arity-lem trace refl refl = refl
erase-arity-lem equalsString refl refl = refl
erase-arity-lem encodeUtf8 refl refl = refl
erase-arity-lem decodeUtf8 refl refl = refl
erase-arity-lem fstPair refl refl = refl
erase-arity-lem sndPair refl refl = refl
erase-arity-lem nullList refl refl = refl
erase-arity-lem headList refl refl = refl
erase-arity-lem tailList refl refl = refl
erase-arity-lem chooseList refl refl = refl
erase-arity-lem constrData refl refl = refl
erase-arity-lem mapData refl refl = refl
erase-arity-lem listData refl refl = refl
erase-arity-lem iData refl refl = refl
erase-arity-lem bData refl refl = refl
erase-arity-lem unConstrData refl refl = refl
erase-arity-lem unMapData refl refl = refl
erase-arity-lem unListData refl refl = refl
erase-arity-lem unIData refl refl = refl
erase-arity-lem unBData refl refl = refl
erase-arity-lem equalsData refl refl = refl
erase-arity-lem chooseData refl refl = refl
erase-arity-lem chooseUnit refl refl = refl
erase-arity-lem mkPairData refl refl = refl
erase-arity-lem mkNilData refl refl = refl
erase-arity-lem mkNilPairData refl refl = refl
erase-arity-lem mkCons refl refl = refl
erase-arity-lem consByteString refl refl = refl
erase-arity-lem sliceByteString refl refl = refl
erase-arity-lem lengthOfByteString refl refl = refl
erase-arity-lem indexByteString refl refl = refl
erase-arity-lem blake2b-256 refl refl = refl

eraseITel : ∀ b {Φ}(Δ : Ctx Φ)(σ : SubNf Φ ∅)
          →  A.ITel b Δ σ → U.ITel b (eraseCtx Δ)

eraseFVal : {A B : ∅ ⊢Nf⋆ *}{t : ∅ A.⊢ A ⇒ B}
  → A.Value t → U.FValue (erase t)
eraseFVal (A.V-ƛ t) = U.V-ƛ (erase t)
eraseFVal (A.V-I⇒ b p q r σ p' vs t) =
  U.V-builtin b (erase-arity-lem b p q) (erase≤C' p') (eraseITel b _ σ vs) (erase t)

eraseVal : {A : ∅ ⊢Nf⋆ *}{t : ∅ A.⊢ A}
  → A.Value t → U.Value (erase t)
eraseVal v@(A.V-ƛ t)  = U.V-F (eraseFVal v)
eraseVal (A.V-Λ t)    = U.V-delay
eraseVal (A.V-wrap v) = eraseVal v
eraseVal (A.V-con cn) = U.V-con (eraseTC {∅}{∅} cn)
eraseVal (A.V-IΠ b p q r σ p' vs t) = U.V-builtin⋆ b (erase-arity-lem b p q) (erase≤C' p') (eraseITel b _ σ vs) (erase t)
eraseVal v@(A.V-I⇒ b p q r σ p₁ x t) = U.V-F (eraseFVal v)

eraseITel b ∅        σ vs             = tt
eraseITel b (Δ ,⋆ J) σ (vs ,, A)      = eraseITel b Δ (σ ∘ S) vs
eraseITel b (Δ , A)  σ (vs ,, t ,, v) =
  eraseITel b Δ σ vs  ,, erase t ,, eraseVal v


eraseErr : ∀{Φ}{A : Φ ⊢Nf⋆ *}{Γ : A.Ctx Φ}{e : Γ A.⊢ A}
  → A.Error e → U.Error (erase e)
eraseErr A.E-error = U.E-error
\end{code}

\begin{code}
erase-decIf : ∀{Φ}{Γ : A.Ctx Φ}{A : Φ ⊢Nf⋆ *}{X}(p : Dec X)(t f : Γ A.⊢ A) →
  Util.decIf p (erase t) (erase f) ≡ erase (Util.decIf p t f)
erase-decIf (yes p) t f = refl
erase-decIf (no ¬p) t f = refl
\end{code}

\begin{code}
-- We want that when a builtin eventually computes the untyped and
-- typed semantics would give the same answer. Here we just
-- exhaustively pattern match on the builtin and its typed args to get
-- it to compute.
erase-BUILTIN : ∀ b (σ : SubNf (proj₁ (sig b)) ∅)(vs : A.ITel b (proj₁ (proj₂ (sig b))) σ) →
  proj₁
  (U.IBUILTIN' b (erase-arity-lem b refl refl) (eraseITel b (proj₁ (proj₂ (sig b))) σ vs))
  ≡ erase (proj₁ (A.IBUILTIN b σ vs))
erase-BUILTIN addInteger      σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) = refl
erase-BUILTIN subtractInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) = refl
erase-BUILTIN multiplyInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) = refl
erase-BUILTIN divideInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) with i' ≟ +0
... | yes p = refl
... | no ¬p = refl
erase-BUILTIN quotientInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) with i' ≟ +0
... | yes p = refl
... | no ¬p = refl
erase-BUILTIN remainderInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) with i' ≟ +0
... | yes p = refl
... | no ¬p = refl
erase-BUILTIN modInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) with i' ≟ +0
... | yes p = refl
... | no ¬p = refl
erase-BUILTIN lessThanInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) with i Data.Integer.<? i'
... | yes p = refl
... | no ¬p = refl
erase-BUILTIN lessThanEqualsInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) with i ≤? i'
... | yes p = refl
... | no ¬p = refl
erase-BUILTIN equalsInteger σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (integer i')) with i ≟ i'
... | yes p = refl
... | no ¬p = refl
erase-BUILTIN appendByteString σ ((tt ,, _ ,, A.V-con (bytestring b)) ,, _ ,, A.V-con (bytestring b')) = refl
erase-BUILTIN lessThanByteString σ ((tt ,, _ ,, A.V-con (bytestring b)) ,, _ ,, A.V-con (bytestring b')) = refl
erase-BUILTIN lessThanEqualsByteString σ ((tt ,, _ ,, A.V-con (bytestring b)) ,, _ ,, A.V-con (bytestring b')) = refl
erase-BUILTIN sha2-256 σ (tt ,, _ ,, A.V-con (bytestring b)) = refl
erase-BUILTIN sha3-256 σ (tt ,, _ ,, A.V-con (bytestring b)) = refl
erase-BUILTIN verifyEd25519Signature σ (((tt ,, _ ,, A.V-con (bytestring b)) ,, _ ,, A.V-con (bytestring b')) ,, _ ,, A.V-con (bytestring b'')) with verifyEd25519Sig b b' b''
... | Util.just _ = refl
... | Util.nothing = refl
erase-BUILTIN verifyEcdsaSecp256k1Signature σ (((tt ,, _ ,, A.V-con (bytestring b)) ,, _ ,, A.V-con (bytestring b')) ,, _ ,, A.V-con (bytestring b'')) with verifySchnorrSecp256k1Sig b b' b''
... | Util.just _ = refl
... | Util.nothing = refl
erase-BUILTIN verifySchnorrSecp256k1Signature σ (((tt ,, _ ,, A.V-con (bytestring b)) ,, _ ,, A.V-con (bytestring b')) ,, _ ,, A.V-con (bytestring b'')) with verifySchnorrSecp256k1Sig b b' b''
... | Util.just _ = refl
... | Util.nothing = refl
erase-BUILTIN equalsByteString σ ((tt ,, _ ,, A.V-con (bytestring b)) ,, _ ,, A.V-con (bytestring b')) = refl
erase-BUILTIN ifThenElse σ ((((tt ,, A) ,, _ ,, A.V-con (bool B.false)) ,, t ,, tv) ,, u ,, uv) = refl
erase-BUILTIN ifThenElse σ ((((tt ,, A) ,, _ ,, A.V-con (bool B.true)) ,, t ,, tv) ,, u ,, uv) = refl
erase-BUILTIN appendString σ ((tt ,, _ ,, A.V-con (string s)) ,, _ ,, A.V-con (string s')) = refl
erase-BUILTIN trace σ (((tt ,, A) ,, _ ,, A.V-con (string b)) ,, _ ,, v) = refl
erase-BUILTIN equalsString σ ((tt ,, _ ,, A.V-con (string s)) ,, _ ,, A.V-con (string s')) = refl
erase-BUILTIN encodeUtf8 σ (tt ,, _ ,, A.V-con (string s)) = refl
erase-BUILTIN decodeUtf8 σ (tt ,, _ ,, A.V-con (bytestring b)) with DECODEUTF8 b
... | just _ = refl
... | nothing = refl
erase-BUILTIN fstPair σ vs = refl
erase-BUILTIN sndPair σ vs = refl
erase-BUILTIN nullList σ vs = refl
erase-BUILTIN headList σ vs = refl
erase-BUILTIN tailList σ vs = refl
erase-BUILTIN chooseList σ vs = refl
erase-BUILTIN constrData σ vs = refl
erase-BUILTIN mapData σ vs = refl
erase-BUILTIN listData σ vs = refl
erase-BUILTIN iData σ (tt ,, _ ,, A.V-con (integer i)) = refl
erase-BUILTIN bData σ (tt ,, _ ,, A.V-con (bytestring b)) = refl
erase-BUILTIN unConstrData σ vs = refl
erase-BUILTIN unMapData σ vs = refl
erase-BUILTIN unListData σ vs = refl
erase-BUILTIN unIData σ (tt ,, _ ,, A.V-con (Data (iDATA i))) = refl
erase-BUILTIN unIData σ (tt ,, _ ,, A.V-con (Data (bDATA b))) = refl
erase-BUILTIN unBData σ (tt ,, _ ,, A.V-con (Data (iDATA i))) = refl
erase-BUILTIN unBData σ (tt ,, _ ,, A.V-con (Data (bDATA b))) = refl
erase-BUILTIN equalsData σ vs = refl
erase-BUILTIN chooseData σ vs = refl
erase-BUILTIN chooseUnit σ vs = refl
erase-BUILTIN mkPairData σ vs = refl
erase-BUILTIN mkNilData σ vs = refl
erase-BUILTIN mkNilPairData σ vs = refl
erase-BUILTIN mkCons σ vs = refl
erase-BUILTIN consByteString σ ((tt ,, _ ,, A.V-con (integer i)) ,, _ ,, A.V-con (bytestring b)) = refl
erase-BUILTIN sliceByteString σ (((tt ,, _ ,, A.V-con (integer st)) ,, _ ,, A.V-con (integer n)) ,, _ ,, A.V-con (bytestring b)) = refl
erase-BUILTIN lengthOfByteString σ (tt ,, _ ,, A.V-con (bytestring b)) = refl
erase-BUILTIN indexByteString σ ((tt ,, _ ,, A.V-con (bytestring b)) ,, _ ,, A.V-con (integer i)) with +0 ≤? i
... | no  _ = refl
... | yes _ with i Data.Integer.<? Builtin.length b
... | no  _ = refl
... | yes _ = refl
erase-BUILTIN blake2b-256 σ (tt ,, _ ,, A.V-con (bytestring b)) = refl

erase-BUILTIN' : ∀ b {Φ'}{Γ' : Ctx Φ'}(p : proj₁ (sig b) ≡ Φ')(q : subst Ctx p (proj₁ (proj₂ (sig b))) ≡ Γ')(σ : SubNf Φ' ∅)(vs : A.ITel b Γ' σ){C' : Φ' ⊢Nf⋆ *}(r : subst (_⊢Nf⋆ *) p (proj₂ (proj₂ (sig b))) ≡ C') →
  proj₁
  (U.IBUILTIN' b (erase-arity-lem b p q)
   (eraseITel b Γ' σ vs))
  ≡ erase (proj₁ (A.IBUILTIN' b p q σ vs C' r))
erase-BUILTIN' b refl refl σ vs refl = erase-BUILTIN b σ vs

erase—→ : {A : ∅ ⊢Nf⋆ *}{t t' : ∅ A.⊢ A}
  → t A.—→ t' → erase t U.—→ erase t' ⊎ erase t ≡ erase t'
erase—→ (A.ξ-·₁ {M = M} p)                              = map
  U.ξ-·₁
  (cong (_· erase M))
  (erase—→ p)
erase—→ (A.ξ-·₂ {V = V} p q)                            = map
  (U.ξ-·₂ (eraseFVal p))
  ((cong (erase V ·_)))
  (erase—→ q)
erase—→ (A.ξ-·⋆ p)                                      =
  map U.ξ-force (cong force) (erase—→ p)
erase—→ (A.β-ƛ {N = N}{V = V} v)                   =
  inj₁ (subst ((ƛ (erase N) · erase V) U.—→_) (lem[] N V) (U.β-ƛ (eraseVal v)))
erase—→ (A.β-Λ {N = N}{A = A})                          = inj₁ (subst (force (delay (erase N)) U.—→_) (lem[]⋆ N A) U.β-delay)
erase—→ (A.β-wrap p)                                    = inj₂ refl
erase—→ (A.ξ-unwrap p)                                  = erase—→ p
erase—→ (A.ξ-wrap p)                                    = erase—→ p
erase—→ (A.E-·₂ p)                                      =
  inj₁ (U.E-·₂ (eraseFVal p))
erase—→ A.E-·₁                                          = inj₁ U.E-·₁
erase—→ A.E-·⋆                                          = inj₁ U.E-force
erase—→ A.E-unwrap                                      = inj₂ refl
erase—→ A.E-wrap                                        = inj₂ refl
erase—→ (A.β-sbuiltin b σ p q C' r t u vs v) = inj₁ (subst (_ U.—→_) (erase-BUILTIN' b p q σ (vs ,, u ,, v) r)  (U.β-builtin b (erase t) (erase-arity-lem b p q) (eraseITel b _ σ vs) (eraseVal v)))
erase—→ (A.β-sbuiltin⋆ b {A = A} σ p q C' r t vs) = inj₁ (subst (_ U.—→_) (trans (erase-BUILTIN' b p q (subNf-cons σ A) (vs ,, A) r) (lem-erase refl (subNf-cons-[]Nf C') (proj₁ (A.IBUILTIN' b p q (subNf-cons σ A) (vs ,, A) C' r)))) (U.β-builtin⋆ b (erase t) (erase-arity-lem b p q) (eraseITel b _ σ vs)))
\end{code}

-- returning nothing means that the typed step vanishes

\begin{code}
eraseProgress : {A : ∅ ⊢Nf⋆ *}(M : ∅ A.⊢ A)(p : A.Progress M)
  → U.Progress (erase M)
  ⊎ Σ (∅ A.⊢ A) λ N →  (M A.—→ N) × (erase M ≡ erase N)
eraseProgress M (A.step {N = N} p) =
  map U.step (λ q → N ,, p ,, q) (erase—→ p)
eraseProgress M (A.done V)    = inj₁ (U.done (eraseVal V))
eraseProgress M (A.error e)   = inj₁ (U.error (eraseErr e))

erase-progress : ∀{A}(M : ∅ A.⊢ A)
  → U.Progress (erase M)
  ⊎ Σ (∅ A.⊢ A) λ N →  (M A.—→ N) × (erase M ≡ erase N)
erase-progress t = eraseProgress t (A.progress t)
\end{code}

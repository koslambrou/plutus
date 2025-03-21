-- | The types and functions that are common among all ledger Plutus versions.
module PlutusLedgerApi.Common
    ( -- * Script (de)serialization
      SerialisedScript
    , serialiseCompiledCode
    , serialiseUPLC
    , deserialiseUPLC
    , ScriptDecodeError (..)
    , assertScriptWellFormed

      -- * Script evaluation
    , evaluateScriptCounting
    , evaluateScriptRestricting
    , VerboseMode (..)
    , LogOutput
    , EvaluationError (..)

      -- * Network's versioning
      {-| The network's behaviour (and plutus's by extension) can change via /hard forks/,
      which directly correspond to major-number protocol version bumps.
      -}
    ,  ProtocolVersion (..)
    , LedgerPlutusVersion (..)
    , builtinsIntroducedIn
    , builtinsAvailableIn

      -- * Network's costing parameters
      {-| A less drastic approach (that does not rely on a HF)
      to affect the network's (and plutus's by extension) behaviour
      is by tweaking the values of the cost model parameters.

      The network does not associate names to cost model parameters;
      Plutus attaches names to the network's cost model parameters (values)
      either in a raw textual form or typed by a specific plutus version.

      See Note [Cost model parameters]
      -}
    , CostModelParams
    , toCostModelParams
    , assertWellFormedCostModelParams
    , IsParamName
    , showParamName
    , GenericParamName

      -- ** Evaluation context
    , EvaluationContext (..)
    , mkDynEvaluationContext
    , toMachineParameters
    ) where

import PlutusCore.Evaluation.Machine.CostModelInterface (CostModelParams)
import PlutusLedgerApi.Common.Eval
import PlutusLedgerApi.Common.ParamName
import PlutusLedgerApi.Common.SerialisedScript
import PlutusLedgerApi.Common.Versions

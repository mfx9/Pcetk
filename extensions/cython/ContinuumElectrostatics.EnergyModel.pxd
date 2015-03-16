#-------------------------------------------------------------------------------
# . File      : ContinuumElectrostatics.EnergyModel.pxd
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014-2015)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------
from pCore.cDefinitions                  cimport Boolean, CFalse, CTrue, Integer, Real
from pCore.Status                        cimport Status, Status_Continue, Status_IndexOutOfRange, Status_ValueError
from ContinuumElectrostatics.StateVector cimport CStateVector, StateVector, StateVector_SetSite, StateVector_GetPair

__lastchanged__ = "$Id: $"


# Include EnergyModel.h in the generated C code
cdef extern from "EnergyModel.h":
    ctypedef struct CEnergyModel "EnergyModel":
        CStateVector *vector
        Integer       nstates
        Integer       ninstances
        Real          temperature


    # Allocation and deallocation
    cdef CEnergyModel *EnergyModel_Allocate (Integer nsites, Integer ninstances, Status *status)
    cdef void          EnergyModel_Deallocate (CEnergyModel *self)

    # Handling of the interactions matrix
    cdef Boolean EnergyModel_CheckInteractionsSymmetric (CEnergyModel *self, Real tolerance, Real *maxDeviation)
    cdef void    EnergyModel_SymmetrizeInteractions     (CEnergyModel *self, Status *status)
    cdef void    EnergyModel_ResetInteractions          (CEnergyModel *self)

    # Calculation of energies
    cdef Real EnergyModel_CalculateMicrostateEnergy         (CEnergyModel *self, CStateVector *vector, Real pH)
    cdef Real EnergyModel_CalculateMicrostateEnergyUnfolded (CEnergyModel *self, CStateVector *vector, Real pH)

    # Calculation of partition functions
    cdef Real EnergyModel_CalculateZunfolded (CEnergyModel *self, Real pH, Real Gzero, Status *status)
    cdef Real EnergyModel_CalculateZfolded (CEnergyModel *self, Real pH, Real Gzero, Status *status)

    # Calculation of probabilities
    cdef void EnergyModel_CalculateProbabilitiesAnalytically (CEnergyModel *self, Real pH, Status *status)
    cdef void EnergyModel_CalculateProbabilitiesAnalyticallyUnfolded (CEnergyModel *self, Real pH, Status *status)

    # Monte Carlo-related functions
    cdef Real    EnergyModel_MCScan               (CEnergyModel *self, Real pH, Integer nmoves)
    cdef void    EnergyModel_UpdateProbabilities  (CEnergyModel *self)
    cdef Integer EnergyModel_FindPairs            (CEnergyModel *self, Real limit, Integer npairs, Status *status)
    cdef void    EnergyModel_CalculateProbabilitiesMonteCarlo (CEnergyModel *self, Real pH, Boolean equil, Integer nscans, Status *status)

    # Functions for accessing items
    cdef Real    EnergyModel_GetGmodel         (CEnergyModel *self, Integer instIndexGlobal)
    cdef Real    EnergyModel_GetGintr          (CEnergyModel *self, Integer instIndexGlobal)
    cdef Integer EnergyModel_GetProtons        (CEnergyModel *self, Integer instIndexGlobal)
    cdef Real    EnergyModel_GetProbability    (CEnergyModel *self, Integer instIndexGlobal)
    cdef Real    EnergyModel_GetInteraction    (CEnergyModel *self, Integer instIndexGlobalA, Integer instIndexGlobalB)
    cdef Real    EnergyModel_GetInterSymmetric (CEnergyModel *self, Integer instIndexGlobalA, Integer instIndexGlobalB)
    cdef Real    EnergyModel_GetDeviation      (CEnergyModel *self, Integer instIndexGlobalA, Integer instIndexGlobalB)

    cdef void    EnergyModel_SetGmodel         (CEnergyModel *self, Integer instIndexGlobal, Real value)
    cdef void    EnergyModel_SetGintr          (CEnergyModel *self, Integer instIndexGlobal, Real value)
    cdef void    EnergyModel_SetProtons        (CEnergyModel *self, Integer instIndexGlobal, Integer value)
    cdef void    EnergyModel_SetProbability    (CEnergyModel *self, Integer instIndexGlobal, Real value)
    cdef void    EnergyModel_SetInteraction    (CEnergyModel *self, Integer instIndexGlobalA, Integer instIndexGlobalB, Real value)

#-------------------------------------------------------------------------------
cdef class EnergyModel:
    cdef CEnergyModel  *cObject
    cdef public object  isOwner
    cdef public object  owner

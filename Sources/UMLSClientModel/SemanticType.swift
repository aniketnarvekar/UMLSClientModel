// SemanticType.swift

import Foundation

/// A UMLS Semantic Types
public enum UMLSSemanticType: String, Codable, Sendable, CaseIterable {
  case acquiredAbnormality = "Acquired Abnormality"
  case activity = "Activity"
  case ageGroup = "Age Group"
  case aminoAcidSequence = "Amino Acid Sequence"
  case aminoAcidPeptideOrProtein = "Amino Acid, Peptide, or Protein"
  case amphibian = "Amphibian"
  case anatomicalAbnormality = "Anatomical Abnormality"
  case anatomicalStructure = "Anatomical Structure"
  case animal = "Animal"
  case antibiotic = "Antibiotic"
  case archaeon = "Archaeon"
  case bacterium = "Bacterium"
  case behavior = "Behavior"
  case biologicFunction = "Biologic Function"
  case biologicallyActiveSubstance = "Biologically Active Substance"
  case biomedicalOccupationOrDiscipline = "Biomedical Occupation or Discipline"
  case biomedicalOrDentalMaterial = "Biomedical or Dental Material"
  case bird = "Bird"
  case bodyLocationOrRegion = "Body Location or Region"
  case bodyPartOrganOrOrganComponent = "Body Part, Organ, or Organ Component"
  case bodySpaceOrJunction = "Body Space or Junction"
  case bodySubstance = "Body Substance"
  case bodySystem = "Body System"
  case carbohydrateSequence = "Carbohydrate Sequence"
  case cell = "Cell"
  case cellComponent = "Cell Component"
  case cellFunction = "Cell Function"
  case cellOrMolecularDysfunction = "Cell or Molecular Dysfunction"
  case chemical = "Chemical"
  case chemicalViewedFunctionally = "Chemical Viewed Functionally"
  case chemicalViewedStructurally = "Chemical Viewed Structurally"
  case classification = "Classification"
  case clinicalAttribute = "Clinical Attribute"
  case clinicalDrug = "Clinical Drug"
  case conceptualEntity = "Conceptual Entity"
  case congenitalAbnormality = "Congenital Abnormality"
  case dailyOrRecreationalActivity = "Daily or Recreational Activity"
  case diagnosticProcedure = "Diagnostic Procedure"
  case diseaseOrSyndrome = "Disease or Syndrome"
  case drugDeliveryDevice = "Drug Delivery Device"
  case educationalActivity = "Educational Activity"
  case elementIonOrIsotope = "Element, Ion, or Isotope"
  case embryonicStructure = "Embryonic Structure"
  case entity = "Entity"
  case environmentalEffectOfHumans = "Environmental Effect of Humans"
  case enzyme = "Enzyme"
  case eukaryote = "Eukaryote"
  case event = "Event"
  case experimentalModelOfDisease = "Experimental Model of Disease"
  case familyGroup = "Family Group"
  case finding = "Finding"
  case fish = "Fish"
  case food = "Food"
  case fullyFormedAnatomicalStructure = "Fully Formed Anatomical Structure"
  case functionalConcept = "Functional Concept"
  case fungus = "Fungus"
  case geneOrGenome = "Gene or Genome"
  case geneticFunction = "Genetic Function"
  case geographicArea = "Geographic Area"
  case governmentalOrRegulatoryActivity = "Governmental or Regulatory Activity"
  case group = "Group"
  case groupAttribute = "Group Attribute"
  case hazardousOrPoisonousSubstance = "Hazardous or Poisonous Substance"
  case healthCareActivity = "Health Care Activity"
  case healthCareRelatedOrganization = "Health Care Related Organization"
  case hormone = "Hormone"
  case human = "Human"
  case humanCausedPhenomenonOrProcess = "Human-caused Phenomenon or Process"
  case ideaOrConcept = "Idea or Concept"
  case immunologicFactor = "Immunologic Factor"
  case indicatorReagentOrDiagnosticAid = "Indicator, Reagent, or Diagnostic Aid"
  case individualBehavior = "Individual Behavior"
  case injuryOrPoisoning = "Injury or Poisoning"
  case inorganicChemical = "Inorganic Chemical"
  case intellectualProduct = "Intellectual Product"
  case laboratoryProcedure = "Laboratory Procedure"
  case laboratoryOrTestResult = "Laboratory or Test Result"
  case language = "Language"
  case machineActivity = "Machine Activity"
  case mammal = "Mammal"
  case manufacturedObject = "Manufactured Object"
  case medicalDevice = "Medical Device"
  case mentalProcess = "Mental Process"
  case mentalOrBehavioralDysfunction = "Mental or Behavioral Dysfunction"
  case molecularBiologyResearchTechnique = "Molecular Biology Research Technique"
  case molecularFunction = "Molecular Function"
  case molecularSequence = "Molecular Sequence"
  case naturalPhenomenonOrProcess = "Natural Phenomenon or Process"
  case neoplasticProcess = "Neoplastic Process"
  case nucleicAcidNucleosideOrNucleotide = "Nucleic Acid, Nucleoside, or Nucleotide"
  case nucleotideSequence = "Nucleotide Sequence"
  case occupationOrDiscipline = "Occupation or Discipline"
  case occupationalActivity = "Occupational Activity"
  case organOrTissueFunction = "Organ or Tissue Function"
  case organicChemical = "Organic Chemical"
  case organism = "Organism"
  case organismAttribute = "Organism Attribute"
  case organismFunction = "Organism Function"
  case organization = "Organization"
  case pathologicFunction = "Pathologic Function"
  case patientOrDisabledGroup = "Patient or Disabled Group"
  case pharmacologicSubstance = "Pharmacologic Substance"
  case phenomenonOrProcess = "Phenomenon or Process"
  case physicalObject = "Physical Object"
  case physiologicFunction = "Physiologic Function"
  case plant = "Plant"
  case populationGroup = "Population Group"
  case professionalSociety = "Professional Society"
  case professionalOrOccupationalGroup = "Professional or Occupational Group"
  case qualitativeConcept = "Qualitative Concept"
  case quantitativeConcept = "Quantitative Concept"
  case receptor = "Receptor"
  case regulationOrLaw = "Regulation or Law"
  case reptile = "Reptile"
  case researchActivity = "Research Activity"
  case researchDevice = "Research Device"
  case selfHelpOrReliefOrganization = "Self-help or Relief Organization"
  case signOrSymptom = "Sign or Symptom"
  case socialBehavior = "Social Behavior"
  case spatialConcept = "Spatial Concept"
  case substance = "Substance"
  case temporalConcept = "Temporal Concept"
  case therapeuticOrPreventiveProcedure = "Therapeutic or Preventive Procedure"
  case tissue = "Tissue"
  case vertebrate = "Vertebrate"
  case virus = "Virus"
  case vitamin = "Vitamin"
}

/// A semantic relation label type.
public enum UMLSSemanticTypeRelationLabel: String, Decodable, CaseIterable {
  case adjacentTo = "adjacent_to"
  case affects = "affects"
  case analyzes = "analyzes"
  case assessesEffectOf = "assesses_effect_of"
  case associatedWith = "associated_with"
  case branchOf = "branch_of"
  case bringsAbout = "brings_about"
  case carriesOut = "carries_out"
  case causes = "causes"
  case coOccursWith = "co-occurs_with"
  case complicates = "complicates"
  case conceptualPartOf = "conceptual_part_of"
  case conceptuallyRelatedTo = "conceptually_related_to"
  case connectedTo = "connected_to"
  case consistsOf = "consists_of"
  case contains = "contains"
  case degreeOf = "degree_of"
  case derivativeOf = "derivative_of"
  case developmentalFormOf = "developmental_form_of"
  case diagnoses = "diagnoses"
  case disrupts = "disrupts"
  case evaluationOf = "evaluation_of"
  case exhibits = "exhibits"
  case functionallyRelatedTo = "functionally_related_to"
  case indicates = "indicates"
  case ingredientOf = "ingredient_of"
  case interactsWith = "interacts_with"
  case interconnects = "interconnects"
  case isa = "isa"
  case issueIn = "issue_in"
  case locationOf = "location_of"
  case manages = "manages"
  case manifestationOf = "manifestation_of"
  case measurementOf = "measurement_of"
  case measures = "measures"
  case methodOf = "method_of"
  case occursIn = "occurs_in"
  case partOf = "part_of"
  case performs = "performs"
  case physicallyRelatedTo = "physically_related_to"
  case practices = "practices"
  case precedes = "precedes"
  case prevents = "prevents"
  case processOf = "process_of"
  case produces = "produces"
  case propertyOf = "property_of"
  case resultOf = "result_of"
  case spatiallyRelatedTo = "spatially_related_to"
  case surrounds = "surrounds"
  case temporallyRelatedTo = "temporally_related_to"
  case traverses = "traverses"
  case treats = "treats"
  case tributaryOf = "tributary_of"
  case uses = "uses"
}

/// A value of semantic type.
///
/// The Semantic Value either a semantic type or semantic relation between semantic types.
public enum UMLSSemanticValue {
  /// A semantic type.
  case semanticType(UMLSSemanticType)
  /// A semantic type relation label.
  case relation(UMLSSemanticTypeRelationLabel)
}

extension UMLSSemanticValue: Decodable {
  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)
    if let semanticType = UMLSSemanticType(rawValue: string) {
      self = .semanticType(semanticType)
    } else if let semanticTypeRelationlabel = UMLSSemanticTypeRelationLabel(rawValue: string) {
      self = .relation(semanticTypeRelationlabel)
    } else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription:
          "Cannot initialize UMLSSemanticValue from invalid String value \(string)")
    }
  }
}

extension UMLSSemanticValue: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .semanticType(let value):
      try container.encode(value)
    case .relation(let value):
      try container.encode(value)
    }
  }

}

extension UMLSSemanticTypeRelationLabel: Encodable {}

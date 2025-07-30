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
public enum UMLSSemanticTypeRelationLabel: String, Decodable, CaseIterable, Sendable {
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
public enum UMLSSemanticValue: Sendable {
  /// A semantic type.
  case semanticType(UMLSSemanticType)
  /// A semantic type relation label.
  case relation(UMLSSemanticTypeRelationLabel)
}
extension UMLSSemanticValue: RawRepresentable {

  public var rawValue: String {
    switch self {
    case .semanticType(let value):
      return value.rawValue
    case .relation(let value):
      return value.rawValue
    }
  }

  public init?(rawValue: String) {
    if let semanticType = UMLSSemanticType(rawValue: rawValue) {
      self = .semanticType(semanticType)
    } else if let relation = UMLSSemanticTypeRelationLabel(rawValue: rawValue) {
      self = .relation(relation)
    } else {
      return nil
    }
  }

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

extension UMLSSemanticValue: Equatable {}

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

public enum UMLSSemanticTypeFlag: String, Decodable, CaseIterable, Sendable {
  /// Defined flag
  case defined = "D"
  /// Blocked flag
  case blocked = "B"
  /// Defined but Not Inherited by the children of the Arguments.
  case dni = "DNI"
}

// MARK: - JSON Decoder

/// A semantic type forward relation info
public struct UMLSSemanticTypeRelationInfo: Decodable, Sendable {
  /// A type of relation between the respective relation with request semantic type.
  public let type: UMLSSemanticTypeRelationLabel
  /// A relation object
  public let relation: UMLSSemanticValue
  /// A flag to determine relation state
  public let flag: UMLSSemanticTypeFlag
}

/// An semantic type inverse relation info
public struct UMLSSemanticTypeInverseRelationInfo: Decodable, Sendable {
  /// A type of relation between the respective relation with request semantic type.
  public let type: UMLSSemanticTypeRelationLabel
  /// A flag to determine relation state.
  public let flag: UMLSSemanticTypeFlag
  /// A relation object.
  public let relation: UMLSSemanticValue

  private enum CodingKeys: String, CodingKey {
    case type
    case flag
    case relation = "inverseRelation"
  }

}

/// An object represents inherited semantic type relation information.
public struct UMLSSemanticTypeInheritedRelationInfo: Decodable, Sendable {

  /// A type of relation between the respective relation with requested semantic type.
  public let type: UMLSSemanticTypeRelationLabel
  /// A relation name.
  public let relation: UMLSSemanticValue

  private enum CodingKeys: String, CodingKey {
    case type = "relationType"
    case relation = "relation2"
  }

}

/// An object represents inverse inherited semantic type relation information.
public struct UMLSSemanticTypeInverseInheritedRelationInfo: Decodable, Sendable {
  /// A type of relation between the respective relation with requested semantic type.
  public let type: UMLSSemanticTypeRelationLabel
  /// A relation name.
  public let relation: UMLSSemanticValue

  private enum CodingKeys: String, CodingKey {
    case type = "relationType"
    case relation = "relation1"
  }

}

/// A UMLS semantic type information group.
public struct UMLSSemanticTypeGroupInfo: Decodable, Sendable {
  /// A semantic type group name abbraviation
  public let abbreviation: String
  /// A long-common name.
  public let name: String
  /// A total number of semantic type present in the group.
  public let count: UInt

  private enum CodingKeys: String, CodingKey {
    case abbreviation = "abbreviation"
    case name = "expandedForm"
    case count = "semanticTypeCount"
  }
}

/// An object encapsulates UMLS semantic type information.
public struct UMLSSemanticTypeInfo: Decodable, Sendable {
  /// A semantic type name abbraviation.
  public let abbreviation: String
  /// A unique identifier
  public let ui: UMLSUI<UMLSTUI>
  /// A definition of respecitive semantic type.
  public let definition: String
  /// A usage note if present nil.
  public let usageNote: String?
  /// The value of the respecitve ``ui``.
  public let name: UMLSSemanticValue
  /// A list of forward realtions.
  public let relations: [UMLSSemanticTypeRelationInfo]
  /// A list of inverse relations if any.
  public let inverseRelations: [UMLSSemanticTypeInverseRelationInfo]
  /// A list of inherited relations.
  public let inheritedRelations: [UMLSSemanticTypeInheritedRelationInfo]
  /// A list of inverse inherited relations.
  public let inverseInheritedRelations: [UMLSSemanticTypeInverseInheritedRelationInfo]
  /// Total number of childrens for respective ``ui``.
  public let count: UInt
  /// A semantic type group information if any.
  public let group: UMLSSemanticTypeGroupInfo?

  private enum CodingKeys: String, CodingKey {
    case abbreviation
    case ui
    case definition
    case usageNote
    case name
    case relations
    case inverseRelations
    case inheritedRelations
    case inverseInheritedRelations
    case count = "childCount"
    case group = "semanticTypeGroup"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.abbreviation = try container.decodeNonEmptyString(forKey: .abbreviation)
    self.ui = try container.decode(UMLSUI<UMLSTUI>.self, forKey: .ui)
    self.definition = try container.decodeNonEmptyString(forKey: .definition)
    let note = try container.decode(String.self, forKey: .usageNote)
    self.usageNote = !["", .none].contains(note) ? note : nil
    self.name = try container.decode(UMLSSemanticValue.self, forKey: .name)
    self.relations = try container.decode([UMLSSemanticTypeRelationInfo].self, forKey: .relations)
    self.inverseRelations = try container.decode(
      [UMLSSemanticTypeInverseRelationInfo].self, forKey: .inverseRelations)
    self.inheritedRelations = try container.decode(
      [UMLSSemanticTypeInheritedRelationInfo].self, forKey: .inheritedRelations)
    self.inverseInheritedRelations = try container.decode(
      [UMLSSemanticTypeInverseInheritedRelationInfo].self, forKey: .inverseInheritedRelations)
    self.count = try container.decode(UInt.self, forKey: .count)
    self.group = try container.decodeIfPresent(UMLSSemanticTypeGroupInfo.self, forKey: .group)
  }

}

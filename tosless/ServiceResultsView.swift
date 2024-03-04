//
//  ServiceResultsView.swift
//  tosless
//
//  Created by Joshua Tint on 1/24/24.
//

import SwiftUI
import NaturalLanguage
import CoreML

struct ServiceResultsView: View {
    @State var service: Service?
    @State var details: ResultDetails
    @State var evidence: String?
    @Binding var listedServices: [ResultService]?
    let tosdrService: TosdrService?
    let defaults = UserDefaults()
    let serviceID: UUID
    @State var namingService = false
    @State var newServiceName = ""

    
    init(service: Service, details: ResultDetails, evidence: String, listedServices: Binding<[ResultService]?>, id: UUID) {
        self._service = State(wrappedValue: service)
        self._details = State(wrappedValue: details)
        self._evidence = State(wrappedValue: evidence)
        self._listedServices = listedServices
        self.tosdrService = nil
        self.serviceID = id
        
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "HelveticaNeue-Bold", size: 30)!
        ]
        
    }
    
    init(service: TosdrService, listedServices: Binding<[ResultService]?>) {
        self._details = State(wrappedValue: ResultDetails(details: [:]))
        self.tosdrService = service
        self._listedServices = listedServices
        self.serviceID = UUID()
    }
    
    func deployServiceCreationTask(fromTosdr tosdrService: TosdrService) {
        Task {
            fetchServiceInfoFromID(tosdrService.id) {newService, evidenceURL in
                print("new service fetched: \(newService.name)")
                print("evidence url fetched: \(String(describing: evidenceURL))")
                self.service = newService
                
                fetchEvidenceFromURL(evidenceURL) {newEvidence in
                    self.evidence = newEvidence
                    
                    deployDetailCreationTask(evidence: evidence ?? "")
                }
            }
            
        }
    }
    
    
    func deployDetailCreationTask(evidence: String) {
        
        if (details.completed) {
            return
        }
        
        
        Task {
            let config = MLModelConfiguration()
            
            let model = {() -> NLModel? in
                do {
                    return try NLModel(mlModel: TosClassifier4(configuration: config).model)
                } catch {
                    print(error)
                    return nil
                }
            }()
            
            
            if let model {
                getSentences(evidence) {sentence in
                    Task {
                        let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
                        if trimmedSentence.count > 40 {
                            await details.addDetailFrom(evidence: trimmedSentence, model: model)
                            // print("added from \(trimmedSentence)")
                        }
                    }
                }
            }
            
            details.markCompleted()
            
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                
                HStack {
                    Spacer()
                    Group {
                        DetailSummaryWheel(details: details)
                            .rotation3DEffect(.degrees(details.completed ? 0 : 90), axis: (1,0,0), anchor: .center, anchorZ: 0, perspective: 0.01)
                            .padding(60)
                            .animation(.spring(), value: details.completed)
                    }
                    .compositingGroup()
                    .shadow(color: Color("shadowColor"), radius: 5, x: 0, y: 10)
                    /* VStack(spacing: 10) {
                     HStack {
                     Image(systemName: "eye.circle.fill")
                     .font(.system(size: 60))
                     Image(systemName: "lock.circle.fill")
                     .font(.system(size: 60))
                     }
                     HStack {
                     Image(systemName: "eye.circle.fill")
                     .font(.system(size: 60))
                     Image(systemName: "eye.circle.fill")
                     .font(.system(size: 60))
                     }
                     }
                     .padding()*/
                    Spacer()
                }
                //                .background(
                //                    ZStack {
                //                        RadialGradient(colors: [Color(white: 1.0, opacity: 0.0), Color("BackgroundTranslucent")], center: .center, startRadius: 50, endRadius: 300)
                //                        LinearGradient(colors: [Color(white: 1.0, opacity: 0.9), Color("BackgroundTranslucent")], startPoint: .bottom, endPoint: .top)
                //
                //                    }
                //                )
                
                /*
                 HStack(alignment: .bottom) {
                 Text("Details")
                 .font(.title)
                 .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 30))
                 Button {
                 
                 } label: {
                 Text("See All")
                 }
                 Spacer()
                 }
                 */
                Group {
                    if details.details.count == 0 {
                        if details.completed {
                            Text("No details detected!")
                            Spacer()
                        } else {
                            ProgressView()
                            Spacer()
                        }
                        
                    } else {
                        VStack(spacing: 3) {
                            let featuredDetails = details.featuredDetails
                            ForEach (Array(featuredDetails.enumerated()), id: \.0) {index, detail in
                                
                                let detailAlignment: Alignment = (index == featuredDetails.count-1) ? .bottom : (index == 0 ? .top : .center)
                                
                                NavigationLink {
                                    DetailView(detail: detail)
                                } label: {
                                    detail.badge(alignment: detailAlignment)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        NavigationLink {
                            DetailListView(details: details)
                        } label: {
                            Text("See all Details...")
                        }
                        Spacer()
                    }
                    
                    Spacer(minLength: 60)
                    
                    if details.completed {
                        Text("Nothing on Tosless should be considered legal advice; see an attorney if you seek that. Details are categorized by an algorithm which has the possibility of error, and Tosless isn't a replacement for reading the full terms to which you are bound. Terms agreements and detail information sourced from Tosdr.org. Tosless doesn't endorse any service.")
                            .font(.footnote)
                            .padding()
                    }
                }
                .alert("Please enter the service name", isPresented: $namingService) {
                    TextField("Name", text: $newServiceName)
                    Button("OK") {

                        let idx = listedServices!.firstIndex(where: {$0.id == serviceID})
                        if let idx {
                            listedServices?.remove(at: idx)
                        }

                        if service != nil {
                            service!.name = newServiceName
                        }
                        
                        if idx != nil && evidence != nil {
                            listedServices?.append(ResultService(service: service!, resultDetails: details, evidence: evidence!, id: serviceID))
                        }
                    }
                } message: {
                    Text("Please enter the service name")
                }
            }
        }
        
        .onAppear() {
            if service == nil {
                deployServiceCreationTask(fromTosdr: tosdrService!)
            } else if let evidence = evidence {
                deployDetailCreationTask(evidence: evidence)
            }
        }
        
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    getIconOrDefault(service)
                    
                    Text(service?.name ?? "Loading...")
                            .font(.title)
                            .bold()
                        
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Menu {
                    Button {
                        namingService = true
                    } label: {
                        Text("Edit name")
                        Image(systemName: "pencil")
                    }
                    
                    Button {
                        if let service, let evidence {
                            if listedServices != nil {
                                let idx = listedServices!.firstIndex(where: {$0.id == serviceID})
                                if let idx {
                                    listedServices?.remove(at: idx)
                                } else {
                                    listedServices?.append(ResultService(service: service, resultDetails: details, evidence: evidence, id: serviceID))
                                }
                                
                                let encoder = JSONEncoder()
                                do {
                                    UserDefaults.standard.set(try encoder.encode(listedServices), forKey: "Saved Services")
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    } label: {
                        if let listedServices {
                            if listedServices.contains(where: {$0.id == serviceID}) {
                                Text("Unsave")
                                Image(systemName: "plus.circle.fill")
                            } else if evidence != nil && service != nil {
                                Text("Save")

                                Image(systemName: "plus")
                            } else {
                                Image(systemName: "plus")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        
    }
    
    
    func getIconOrDefault(_ service: Service?) -> AnyView {
        return service?.icon ?? AnyView(
            Image(systemName: "questionmark.square")
                .resizable()
                .font(.system(size: 36))
                .scaledToFit()
                .padding()
                .background(Color("BackgroundColor"))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(width: 30, height: 30)
        )
    }
}



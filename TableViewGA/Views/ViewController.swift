//
//  ViewController.swift
//  TableViewGA
//
//  Created by Marina De Pazzi on 24/05/23.
//

import UIKit

class ViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case nowPlaying
        case popular
        
        var value: String {
            switch self {
                case .nowPlaying:
                    return "Now Playing"
                case .popular:
                    return "Popular"
            }
        }
    }
    
    static let cellID: String = "smallMovieCell"
    static let segueID: String = "toDetails"
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sections: [Section] = Section.allCases
    private var nowPlaying: [Movie] = []
    private var popular: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            self.popular = try DataModel.fetchMovies()
                .sorted(by: { $0.voteAverage > $1.voteAverage })
            self.nowPlaying = try DataModel.fetchMovies(from: .nowPlaying)
                .sorted(by: { $0.voteAverage > $1.voteAverage })
        }
        catch {
            print(error)
        }
        
        self.reloadData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.segueID,
           let movie = sender as? Movie {
            let destination = segue.destination as! DetailsViewController
            
            destination.movie = movie
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentSection = self.sections[indexPath.section]
        
        switch currentSection {
            case .nowPlaying:
                self.performSegue(withIdentifier: Self.segueID, sender: self.nowPlaying[indexPath.row])
            case .popular:
                self.performSegue(withIdentifier: Self.segueID, sender: self.popular[indexPath.row])
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].value
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        var content = header.defaultContentConfiguration()
        
        content.text = self.sections[section].value
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        content.textProperties.color = .label
        
        header.contentConfiguration = content
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = self.sections[section]
        
        switch currentSection {
            case .nowPlaying:
                return self.nowPlaying.count
            case .popular:
                return self.popular.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = self.sections[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID, for: indexPath) as! SmallMovieCell
        switch currentSection {
            case .nowPlaying:
                cell.posterView.image = self.nowPlaying[indexPath.row].imageCover
                cell.titleLabel.text = self.nowPlaying[indexPath.row].title
                cell.descriptionLabel.text = self.nowPlaying[indexPath.row].overview
                cell.ratingLabel.text = "\(self.nowPlaying[indexPath.row].voteAverage)"
                
                return cell
            case .popular:
                cell.titleLabel.text = self.popular[indexPath.row].title
                cell.descriptionLabel.text = self.popular[indexPath.row].overview
                cell.ratingLabel.text = "\(self.popular[indexPath.row].voteAverage)"
                cell.posterView.image = self.popular[indexPath.row].imageCover
                
                return cell
        }
    }
}

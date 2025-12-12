import UIKit

protocol MovieDetailView: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showMovie(_ movie: Movie)
    func showError(_ message: String)
}

final class MovieDetailViewController: BaseViewController, MovieDetailView {

    // MARK: - Outlets (conectados desde MovieDetailViewController.xib)

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    @IBOutlet weak var recommendButton: UIButton!

    // MARK: - Dependencias

    var presenter: MovieDetailPresenter!

    private var movie: Movie?
    private var imageURLs: [URL] = []
    private var actors: [Actor] = []

    // MARK: - Ciclo de vida

    /// Igual que hicimos en Splash y Categories:
    /// cargamos el XIB manualmente para evitar el crash
    /// "view outlet was not set".
    override func loadView() {
        let nib = UINib(nibName: "MovieDetailViewController", bundle: nil)

        guard let rootView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("No se pudo instanciar la vista raíz desde MovieDetailViewController.xib")
        }

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.onViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imagesCollectionView.collectionViewLayout.invalidateLayout()
        actorsCollectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Collection de imágenes (carrusel)
        if let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
        } else {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
            imagesCollectionView.collectionViewLayout = layout
        }

        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.isPagingEnabled = true
        imagesCollectionView.showsHorizontalScrollIndicator = false
        imagesCollectionView.alwaysBounceHorizontal = true

        imagesCollectionView.register(
            UINib(nibName: "MovieImageCarouselCell", bundle: nil),
            forCellWithReuseIdentifier: "MovieImageCarouselCell"
        )
        
        if let actorsLayout = actorsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            actorsLayout.scrollDirection = .horizontal
            actorsLayout.minimumLineSpacing = 8
            actorsLayout.minimumInteritemSpacing = 8
            actorsLayout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            let actorsLayout = UICollectionViewFlowLayout()
            actorsLayout.scrollDirection = .horizontal
            actorsLayout.minimumLineSpacing = 8
            actorsLayout.minimumInteritemSpacing = 8
            actorsLayout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
            actorsCollectionView.collectionViewLayout = actorsLayout
        }

        actorsCollectionView.dataSource = self
        actorsCollectionView.delegate = self
        actorsCollectionView.showsHorizontalScrollIndicator = false

        actorsCollectionView.register(
            UINib(nibName: "ActorCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ActorCollectionViewCell"
        )
    }

    // MARK: - MovieDetailView

    func showLoading(_ isLoading: Bool) {
        // Mostrar loader
    }

    func showMovie(_ movie: Movie) {
        self.movie = movie
        title = movie.title

        titleLabel.text = movie.title
        ratingLabel.text = String(format: "%.1f", movie.rating)

        if let attr = NSAttributedString(
            htmlString: movie.overviewHTML,
            font: UIFont.systemFont(ofSize: 14)
        ) {
            descriptionLabel.attributedText = attr
        } else {
            descriptionLabel.text = movie.overviewHTML
        }

        imageURLs = movie.imageURLs
        actors = movie.actors

        pageControl.numberOfPages = max(imageURLs.count, 1)
        pageControl.currentPage = 0

        imagesCollectionView.reloadData()
        actorsCollectionView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Actions

    @IBAction func recommendTapped(_ sender: UIButton) {
        guard let movie = movie else { return }
        MovieDetailRouter.presentRecommend(from: self, movie: movie)
    }
}

// MARK: - UICollectionViewDataSource & DelegateFlowLayout

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollectionView {
            return max(imageURLs.count, 1)
        } else {
            return actors.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == imagesCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MovieImageCarouselCell",
                for: indexPath
            ) as! MovieImageCarouselCell

            if imageURLs.isEmpty {
                cell.configurePlaceholder()
            } else {
                let url = imageURLs[indexPath.item]
                cell.configure(with: url)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ActorCollectionViewCell",
                for: indexPath
            ) as! ActorCollectionViewCell
            cell.configure(with: actors[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == imagesCollectionView {
            return CGSize(width: collectionView.bounds.width,
                          height: collectionView.bounds.height)
        } else {
            return CGSize(width: 120, height: 100)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imagesCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
            pageControl.currentPage = page
        }
    }
}

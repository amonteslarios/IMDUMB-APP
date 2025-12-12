import UIKit

protocol CategoriesView: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showCategories(_ categories: [MovieCategory])
    func showError(_ message: String)
}

final class CategoriesViewController: BaseViewController, CategoriesView {

    // MARK: - Outlets (desde CategoriesViewController.xib)
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Dependencias
    var presenter: CategoriesPresenter!
    private var categories: [MovieCategory] = []

    // MARK: - Ciclo de vida

    /// Igual que en Splash: cargamos el XIB manualmente para evitar
    /// el crash de "view outlet was not set" que a veces da UIKit.
    override func loadView() {
        let nib = UINib(nibName: "CategoriesViewController", bundle: nil)

        guard let rootView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("No se pudo instanciar la vista raíz desde CategoriesViewController.xib")
        }

        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categorías"
        setupCollectionView()
        presenter.onViewDidLoad()
    }

    // MARK: - Setup UI

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            UINib(nibName: "CategoryCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "CategoryCollectionViewCell"
        )
    }

    // MARK: - CategoriesView

    func showLoading(_ isLoading: Bool) {
        // Podrías mostrar un loader general si quieres
    }

    func showCategories(_ categories: [MovieCategory]) {
        self.categories = categories
        collectionView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CategoryCollectionViewCell",
            for: indexPath
        ) as! CategoryCollectionViewCell

        let category = categories[indexPath.item]
        cell.configure(with: category, delegate: self)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
  
        let width = collectionView.bounds.width - 32

        let category = categories[indexPath.item]
        let moviesCount = category.movies.count

        let headerHeight: CGFloat = 40    // título + padding
        let verticalPadding: CGFloat = 16 // espacio extra superior/inferior

        let tableHeight = CGFloat(moviesCount) * MovieTableViewCell.rowHeight

        let totalHeight = headerHeight + tableHeight + verticalPadding

        return CGSize(width: width, height: totalHeight)
    }
}

// MARK: - CategoryCellDelegate

extension CategoriesViewController: CategoryCellDelegate {
    func didSelect(movie: Movie) {
        CategoriesRouter.navigateToMovieDetail(from: self, movieId: movie.id)
    }
}

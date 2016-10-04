SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `progestock`.`type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`type` (
  `idtype` INT NOT NULL AUTO_INCREMENT,
  `libele` VARCHAR(45) NULL,
  PRIMARY KEY (`idtype`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progestock`.`produit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`produit` (
  `idpoduit` INT NOT NULL AUTO_INCREMENT,
  `libele` VARCHAR(255) NULL,
  `prixUnitaire` INT NULL,
  `type` INT NOT NULL,
  PRIMARY KEY (`idpoduit`),
  INDEX `fk_produit_type_idx` (`type` ASC),
  CONSTRAINT `fk_produit_type`
    FOREIGN KEY (`type`)
    REFERENCES `progestock`.`type` (`idtype`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `progestock`.`fournisseur`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`fournisseur` (
  `nom` VARCHAR(255) NULL,
  `prenom` VARCHAR(255) NULL,
  `cni` INT NULL,
  `adresse` VARCHAR(255) NULL DEFAULT CURRENT_TIMESTAMP,
  `telephone` INT NULL,
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `progestock`.`gerant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`gerant` (
  `nom` VARCHAR(255) NULL,
  `prenom` VARCHAR(255) NULL,
  `cni` INT NULL,
  `adresse` VARCHAR(255) NULL DEFAULT CURRENT_TIMESTAMP,
  `telephone` INT NULL,
  `id` INT NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `progestock`.`commande`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`commande` (
  `idcommande` INT NOT NULL AUTO_INCREMENT,
  `quantite` INT NULL,
  `date` DATETIME NULL,
  `produit_idpoduit` INT NOT NULL,
  `fournisseur_id` INT NOT NULL,
  `gerant_id` INT NOT NULL,
  PRIMARY KEY (`idcommande`, `produit_idpoduit`, `fournisseur_id`, `gerant_id`),
  INDEX `fk_commande_produit1_idx` (`produit_idpoduit` ASC),
  INDEX `fk_commande_fournisseur1_idx` (`fournisseur_id` ASC),
  INDEX `fk_commande_gerant1_idx` (`gerant_id` ASC),
  CONSTRAINT `fk_commande_produit1`
    FOREIGN KEY (`produit_idpoduit`)
    REFERENCES `progestock`.`produit` (`idpoduit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_commande_fournisseur1`
    FOREIGN KEY (`fournisseur_id`)
    REFERENCES `progestock`.`fournisseur` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_commande_gerant1`
    FOREIGN KEY (`gerant_id`)
    REFERENCES `progestock`.`gerant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progestock`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`client` (
  `nom` VARCHAR(255) NULL,
  `prenom` VARCHAR(255) NULL,
  `cni` INT NULL,
  `adresse` VARCHAR(255) NULL DEFAULT CURRENT_TIMESTAMP,
  `telephone` INT NULL,
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `progestock`.`achat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`achat` (
  `idachat` INT NOT NULL AUTO_INCREMENT,
  `produit_idpoduit` INT NOT NULL,
  `client_id` INT NOT NULL,
  `date` DATETIME NULL,
  `quantite` INT NULL,
  PRIMARY KEY (`idachat`, `produit_idpoduit`, `client_id`),
  INDEX `fk_achat_produit1_idx` (`produit_idpoduit` ASC),
  INDEX `fk_achat_client1_idx` (`client_id` ASC),
  CONSTRAINT `fk_achat_produit1`
    FOREIGN KEY (`produit_idpoduit`)
    REFERENCES `progestock`.`produit` (`idpoduit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_achat_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `progestock`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progestock`.`typeAchat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`typeAchat` (
  `idtypeAchat` INT NOT NULL,
  `achat_idachat` INT NOT NULL AUTO_INCREMENT,
  `achat_produit_idpoduit` INT NOT NULL,
  `achat_client_id` INT NOT NULL,
  `typeAchat` VARCHAR(45) NULL,
  `pourcentage` INT NULL,
  PRIMARY KEY (`achat_idachat`, `idtypeAchat`, `achat_produit_idpoduit`, `achat_client_id`),
  INDEX `fk_typeAchat_achat1_idx` (`achat_idachat` ASC, `achat_produit_idpoduit` ASC, `achat_client_id` ASC),
  CONSTRAINT `fk_typeAchat_achat1`
    FOREIGN KEY (`achat_idachat` , `achat_produit_idpoduit` , `achat_client_id`)
    REFERENCES `progestock`.`achat` (`idachat` , `produit_idpoduit` , `client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progestock`.`facture`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`facture` (
  `idfacture` INT NOT NULL AUTO_INCREMENT,
  `achat_idachat` INT NOT NULL,
  `achat_produit_idpoduit` INT NOT NULL,
  `achat_client_id` INT NOT NULL,
  `gerant_id` INT NOT NULL,
  `montantVersee` INT NULL,
  `montantRestante` INT NULL,
  PRIMARY KEY (`idfacture`, `achat_idachat`, `achat_produit_idpoduit`, `achat_client_id`),
  INDEX `fk_facture_achat1_idx` (`achat_idachat` ASC, `achat_produit_idpoduit` ASC, `achat_client_id` ASC),
  INDEX `fk_facture_gerant1_idx` (`gerant_id` ASC),
  CONSTRAINT `fk_facture_achat1`
    FOREIGN KEY (`achat_idachat` , `achat_produit_idpoduit` , `achat_client_id`)
    REFERENCES `progestock`.`achat` (`idachat` , `produit_idpoduit` , `client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_facture_gerant1`
    FOREIGN KEY (`gerant_id`)
    REFERENCES `progestock`.`gerant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progestock`.`stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`stock` (
  `idstock` INT NOT NULL,
  `produit_idpoduit` INT NOT NULL,
  `quantite` INT NULL,
  PRIMARY KEY (`idstock`, `produit_idpoduit`),
  INDEX `fk_stock_produit1_idx` (`produit_idpoduit` ASC),
  CONSTRAINT `fk_stock_produit1`
    FOREIGN KEY (`produit_idpoduit`)
    REFERENCES `progestock`.`produit` (`idpoduit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progestock`.`inventaire`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `progestock`.`inventaire` (
  `idinventaire` INT NOT NULL,
  `stock_idstock` INT NOT NULL,
  `date` DATETIME NULL,
  `periode` VARCHAR(255) NULL,
  `quantiteAvant` INT NULL,
  `quantiteApres` INT NULL,
  `coutGlobal` INT NULL,
  PRIMARY KEY (`idinventaire`),
  INDEX `fk_inventaire_stock1_idx` (`stock_idstock` ASC),
  CONSTRAINT `fk_inventaire_stock1`
    FOREIGN KEY (`stock_idstock`)
    REFERENCES `progestock`.`stock` (`idstock`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

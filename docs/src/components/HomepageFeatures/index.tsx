import React, {JSX} from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  image: string;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Intuitiver Kalender',
    image: require('@site/static/img/logo_vertical.png').default,
    description: (
      <>
        Behalte mit einer klaren Monatsansicht stets den Überblick über deine
        Schichten. Vergangene und zukünftige Dienste sind auf einen Blick ersichtlich.
      </>
    ),
  },
  {
    title: 'Automatische Synchronisierung',
    image: require('@site/static/img/logo_vertical.png').default,
    description: (
      <>
        Deine Schichtdaten werden direkt und sicher von der zentralen Datenbank
        geladen. Du bist immer auf dem neuesten Stand, ohne manuelle Eingriffe.
      </>
    ),
  },
  {
    title: 'Dynamische Schichtfarben',
    image: require('@site/static/img/logo_vertical.png').default,
    description: (
      <>
        Jeder Schichttyp hat eine eigene, anpassbare Farbe. Das sorgt für maximale
        Übersichtlichkeit und schnelle Erfassung deines Monatsplans.
      </>
    ),
  },
];

function Feature({title, image, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <img src={image} className={styles.featureSvg} role="img"  alt={''}/>
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
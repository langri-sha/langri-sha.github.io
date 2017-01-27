import {OutboundLink} from '../../lib/analytics'
import {Icon} from '../../lib/icon'
import styles from './styles'

export default () => (
  <header className={styles.header}>
    <h1 className={styles.title}>Langri-Sha</h1>
    <nav className={styles.nav}>
      {[
        [
          'stackoverflow',
          'Stack Overflow', 'https://stackoverflow.com/users/44041/filip-dupanovi%C4%87?tab=profile',
          'StackOverflow profile #SOreadytohelp 💓'
        ],
        [
          'keybase',
          'Keybase', 'https://keybase.io/langrisha',
          'Identity details on Keybase.io'
        ],
        [
          'github',
          'GitHub', 'https://github.com/langri-sha',
          'GitHub profile'
        ],
        [
          'docker',
          'Docker', 'https://hub.docker.com/u/langrisha/',
          'Docker Hub profile'
        ],
        [
          'npm',
          'NPM', 'https://www.npmjs.com/~langri-sha',
          'NPM profile'
        ]
      ].map(([symbol, name, href, title]) => (
        <SocialLink key={symbol} symbol={symbol} name={name} href={href} title={title} />
      ))}
    </nav>
  </header>
)

const SocialLink = ({symbol, name, href, title}) => (
  <OutboundLink
    href={href} category={'Social Links'} label={name}
    className={styles.link} title={title} target={'_blank'}>
    <Icon symbol={symbol} />
  </OutboundLink>
)
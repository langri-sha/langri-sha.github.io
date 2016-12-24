import React, {Component, PropTypes} from 'react'

export const ga = window.ga = window.ga || function () {
  (ga.q = ga.q || []).push(arguments)
}

export class Analytics extends Component {
  static propTypes = {
    id: PropTypes.string.isRequired
  };

  componentDidMount () {
    const script = document.createElement('script')
    script.src = 'https://www.google-analytics.com/analytics.js'
    script.async = true

    document.body.appendChild(script)
  }

  render () {
    ga.l = +new Date()

    ga('create', this.props.id, 'auto')
    ga('send', 'pageview')

    return null
  }
}

export class OutboundLink extends Component {
  static propTypes = {
    href: PropTypes.string.isRequired,
    category: PropTypes.string,
    action: PropTypes.string,
    label: PropTypes.string
  }

  static defaultProps = {
    category: 'Outbound Link',
    action: 'click'
  }

  track (href, category, action, label) {
    ga('send', 'event', {
      eventCategory: category,
      eventAction: action,
      eventLabel: label || href
    })
  }

  render () {
    const {href, category, action, label, children, ...props} = this.props
    const track = this.track.bind(this, href, category, action, label)

    return (
      <a href={href} onClick={track} {...props}>
        {children}
      </a>
    )
  }
}
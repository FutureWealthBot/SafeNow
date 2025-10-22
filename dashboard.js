import { useEffect, useState } from 'react'
import supabase from '../lib/supabaseClient'

export default function Dashboard() {
  const [user, setUser] = useState(null)

  useEffect(() => {
    supabase.auth.getUser().then(({ data: { user } }) => {
      setUser(user)
    })
  }, [])

  if (!user) {
    return <div>Please log in</div>
  }

  return (
    <div>
      <h1>Welcome {user.email} 👋</h1>
      <p>You are now logged in to FutureWealthBot 🚀</p>
    </div>
  )
}

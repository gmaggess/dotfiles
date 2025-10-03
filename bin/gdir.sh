for d in */; do
  if [ -d "$d/.git" ]; then
    echo "Resetting $d"
    (cd "$d" && git reset --hard)
    echo "Updating $d"
    (cd "$d" && git pull --rebase)
  fi
done
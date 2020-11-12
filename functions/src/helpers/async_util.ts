// https://gist.github.com/yongjun21/ec0ea757b9dcbf972a351453755cadcb
export const map = async (iterable: any, mapper: any, options?: any) => {
  options = options || {};
  let concurrency = options.concurrency || Infinity;

  let index = 0;
  const results: any[] = [];
  const iterator = iterable[Symbol.iterator]();
  const promises = [];

  while (concurrency-- > 0) {
    const promise = wrappedMapper();
    if (promise) promises.push(promise);
    else break;
  }

  return Promise.all(promises).then(() => results);

  function wrappedMapper(): any {
    const next = iterator.next();
    if (next.done) return null;
    const i = index++;
    const mapped = mapper(next.value, i);
    return Promise.resolve(mapped).then((resolved) => {
      results[i] = resolved;
      return wrappedMapper();
    });
  }
};

export const all = async (promises: any) => {
  return Promise.all(promises);
};

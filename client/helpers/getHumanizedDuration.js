export const getHumanizedDuration = (start, end) => {
    if (typeof moment === 'undefined') {
        return '';
    }

    const startMoment = moment(start);
    const endMoment = moment(end);

    const years = endMoment.diff(startMoment, 'years');
    if (years !== 0) {
        return `${years} years`;
    }

    const months = endMoment.diff(startMoment, 'months');
    if (months !== 0) {
        return `${months} months`;
    }

    const days = endMoment.diff(startMoment, 'days');
    if (days !== 0) {
        return `${days} days`;
    }

    return `${endMoment.diff(startMoment)} ms`;
};

if (typeof window !== 'undefined') {
    window.getHumanizedDuration = getHumanizedDuration;
}

export default getHumanizedDuration;

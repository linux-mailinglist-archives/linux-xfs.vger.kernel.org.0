Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94962F38BF
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Jan 2021 19:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406632AbhALSXq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Jan 2021 13:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406558AbhALSXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 13:23:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624B9C061387
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 10:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GHMnyHfKYrDnEikfo+CgD9XmU6fZ+3r3RTN2szCUNTg=; b=MXfI1EZHuQ5v3eoKUFO589I/Ev
        WTJHle5JmpzSC2TiryZ2ghLuCVoABj3KGXHpPvrOVYPXgXKjdxJOyz5J5utDkEPpGB+2JRxdgnrbl
        CI3xlsZQE8L99FgkKudxADdmTxVC9CS6G4YEWrBaYGrevwlIKd1n3Qdy3d2Q63X5n6isLjhmNv7rm
        hLxie1se7lM5OCMPjg6n+dO5wT68vUbaw6t0gd6a6PIwLukpqKmVm5/GclaGjB7j0Fm2hY3GUnKyj
        licQ3gJWVTYQBgj/hDKdmVzDc0V5CAl7+v6gAkrdsjyYsBYEzrsOXXIgSNMefOv/FZ5oGueK6Lmph
        1EMqYOBQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kzOHl-005AkC-Qt; Tue, 12 Jan 2021 18:21:21 +0000
Date:   Tue, 12 Jan 2021 18:20:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: sync lazy sb accounting on quiesce of read-only
 mounts
Message-ID: <20210112182053.GB1228497@infradead.org>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-2-bfoster@redhat.com>
 <20210111173851.GD848188@infradead.org>
 <20210112145519.GA1131084@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112145519.GA1131084@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 12, 2021 at 09:55:19AM -0500, Brian Foster wrote:
> xfs_log_unmount_write() does have a shutdown check, it just doesn't show
> up in the diff because I wanted to retain the post-log force check in
> that function (in the event that the force triggers a shutdown).

Ok.  Maybe mention you are throwing in another shutdown check just
because we can't have 'nough of them.

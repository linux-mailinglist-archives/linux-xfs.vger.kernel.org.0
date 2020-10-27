Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5129C7B7
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Oct 2020 19:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753196AbgJ0SrB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Oct 2020 14:47:01 -0400
Received: from casper.infradead.org ([90.155.50.34]:53136 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2901244AbgJ0Squ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 14:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v6yTz7aVYc5/TygJ9NspKkZCEEAT2RenaIMTOqnZYNk=; b=ev6+cfhMnpvzu2Ytv0CiucxHhN
        p0ygdaTtoe+gKK5GCEg02bEOmf+ZM39QENgJqF2pBNB7US2DLCyGdgTxEg9E8D7/DtlNklSjSM73E
        ifrdAt741bD5iidvrxI51dySoMjOWOZcevYae7zHz61ndSsBBp2+GpZG0HoP7HXCukzxiz8aBapEJ
        ssbZZ5VWprh8sB7pVJVFDCXqg3C8ZCKERC8Q29gbjAe6ZRShr6i+4mkhve/91rdBT3PWIgLMfEE98
        4m+L8S5J+r/tkd3czVNvTFjL1A11inY0LiWlF3JZHqpBNM8V2GCk9D6v0i0gA5KLlHhCP6/Of9tPX
        Re3xYtDA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXTzP-0003ce-AP; Tue, 27 Oct 2020 18:46:35 +0000
Date:   Tue, 27 Oct 2020 18:46:35 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, xiakaixu1987@gmail.com,
        linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unused BBMASK macro
Message-ID: <20201027184635.GB12824@infradead.org>
References: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
 <c1453fb1-3e84-677c-15ab-7f51ca758862@sandeen.net>
 <20201019160802.GI9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019160802.GI9832@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 19, 2020 at 09:08:02AM -0700, Darrick J. Wong wrote:
> $ grep BBMASK /usr/include/
> /usr/include/xfs/xfs_fs.h:868:#define BBMASK            (BBSIZE-1)
> 
> This ships in a user-visible header file, so it can only be removed by
> going through the deprecation process.

I don't think we had such a strong process before.  Not that I'm going
to complain much.

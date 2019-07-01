Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E705B728
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 10:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfGAItq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 04:49:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfGAItq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 04:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UIgV7gmEgnM4rtjlSnb6CYa3DCfDzyjEPfuxRn8BHEo=; b=bhiyH5jTqHmMPiGl8Mcw1gUNb
        Cpw5RKwy4OLBI6Uz0FMQAyOf+ojUXVnrUMAvG67MuEIbYV5CpHkcTajKzgJ3qctjkUey17iWU9EPi
        f/d9zpvzDtXpYdhhP5Hxn8Y3hz1VYBrMNut65h76upmcJqPC/lN8b35f4bkUorxQjrF5Z918QWK3L
        SQ8Ho92IezfLcGsA0WVDWA1CyfAlyD8bKOl6Oh4s4qEQ9LsL382PSTxZrRkVwUIWanVYSgQpbOFsk
        XpP27X/6qQKTfS0w1Kq+ew5lXmVdmBCjjdlsP7YPZS5O8l/xx9IYh/9lm2dPFi4mndKEZ39I3qm3W
        eN6XggH+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hhs0P-0000iL-Tk; Mon, 01 Jul 2019 08:49:45 +0000
Date:   Mon, 1 Jul 2019 01:49:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next *rebased* to 73d30d48749f
Message-ID: <20190701084945.GA1356@infradead.org>
References: <20190630163404.GG1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630163404.GG1404256@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 30, 2019 at 09:34:04AM -0700, Darrick J. Wong wrote:
> **NOTE** I discovered while bisecting the previous for-next that I
> introduced a build failure in "xfs: move xfs_ino_geometry to xfs_shared.h"
> that I hadn't noticed because apparently 0day doesn't do commit by
> commit build tests anymore?  (Frankly, it doesn't tell me /anything/
> unless it finds failures, so I think I'm not going to rely on cloud
> kernel build tests anymore.)

The buildbot doesn't seem to work at all basically.  Once it a while
it reports occasional errors for week old trees, but otherwise it
stays entirely silent, even for completely b0rked trees.  I've been
bitten by this more than once in the last weeks.

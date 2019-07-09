Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE42A63B5B
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 20:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfGISqA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 14:46:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfGISp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 14:45:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t9OheTk/YXmum441O9ftZpFS9er/+zh95pKwld4fGAw=; b=ZcfRHgdS5dZvpbhFJB5Y0+kTo
        WoQP5pNcBks0NdLdZJBi5ZIvoFX3KLMPFPjbKmoSDcP1t7FO0vcsi5wf/gwHzD7p82IbDDPxr7kuG
        YJcR0YmuBQF+RaFvPj2L5lS1N9FVSinAFg7VP+kbBifFL9Cdf1205aIQJd/3U4ZW59StzWS6JKWDp
        XrfCGCf/KOuuhbVCQ6fj4mbl8zKfDMGgi/tVE/c7TIYWuNkOLamj3vglYxwp1ZjFIHi59KAtW/rOz
        LE/prG1uIYmYS0wZ0yls2oZVJpUfjmYkeECSPltgEWlLBrSE62BTyCqNObVz6/bG2++eqs6odRD/w
        czShoCIyA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hkv7n-00071T-72; Tue, 09 Jul 2019 18:45:59 +0000
Date:   Tue, 9 Jul 2019 11:45:59 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [linux-kernel-mentees] [PATCH v6] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190709184559.GL32320@bombadil.infradead.org>
References: <20190709124859.GA21503@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709124859.GA21503@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 01:48:59PM +0100, Sheriff Esseson wrote:
> Convert xfs.txt to ReST, rename and fix broken references, consequently.
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
> ---
> 
> Changes in v6:
> 	- undo text reflow from v5.
> 	- fix a typo.
> 	- change indication of defaults , as suggested by Darrick J. Wong, to
> 	  keep the read simple.
> 	- change delimiter of boolean option from a newline to an "or" (clue
> 	  from something like "<option> and <another option>" in the text)
> 	  because the former does not render well in html.
> 
>  Documentation/filesystems/dax.txt             |   2 +-
>  Documentation/filesystems/index.rst           |   1 +
>  .../filesystems/{xfs.txt => xfs.rst}          | 123 +++++++++---------
>  MAINTAINERS                                   |   2 +-
>  4 files changed, 61 insertions(+), 67 deletions(-)
>  rename Documentation/filesystems/{xfs.txt => xfs.rst} (81%)

Documentation/{filesystem/xfs.txt => admin-guide/xfs.rst}.

> -	If "largeio" specified, a filesystem that was created with a
> -	"swidth" specified will return the "swidth" value (in bytes)
> -	in st_blksize. If the filesystem does not have a "swidth"
> -	specified but does specify an "allocsize" then "allocsize"
> +	If ``largeio`` specified, a filesystem that was created with a

surely 'If ``largeio`` is specified' here?

> +	``swidth`` specified will return the ``swidth`` value (in bytes)
> +	in ``st_blksize``. If the filesystem does not have a ``swidth``
> +	specified but does specify an ``allocsize`` then ``allocsize``
>  	(in bytes) will be returned instead. Otherwise the behaviour

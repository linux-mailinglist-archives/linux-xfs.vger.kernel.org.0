Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0B45A80E
	for <lists+linux-xfs@lfdr.de>; Sat, 29 Jun 2019 03:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfF2Blj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 21:41:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42214 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF2Blj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 21:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uZry5nOKE0RdjtGQW20tgZ++YaVaPCtY5Y/rs8C+Lf8=; b=LmDgU/vGTOxmGauugqKzplBDm
        SuPGk5nuRE3SwxoDOaPxYPkT502BNZpExJierNW+ab6Q7BGpu9nFIMRYxa1b6kyBTP8KU4lMXgqhW
        Ng1DxhFQLS/9Sk4kohiKko1F+XzMXkG1trOakC3/1JA8V1xgU1a87BzxADK+mle6vas3nKn5g4Tcf
        +sLmMHyHKpCgMkbNFwk0H0iWpGvcL89KvBO/3uUKcWMDJUkuqeH37eT6mIRojU8o6JFqCUzXnzcrW
        YWxfD2mD0MYEQLDKxs3HEarP5pBGNuHvA7sxijBVbOWhUR1lxbxJgN+SP7DblEhhLRNVVpQHEuYaa
        OtkpCtFtg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hh2My-0005GU-C6; Sat, 29 Jun 2019 01:41:36 +0000
Date:   Fri, 28 Jun 2019 18:41:36 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v1] Doc : fs : convert xfs.txt to ReST
Message-ID: <20190629014136.GF4286@bombadil.infradead.org>
References: <20190628214302.GA12096@localhost>
 <20190629010733.GA31770@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190629010733.GA31770@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 29, 2019 at 02:25:08AM +0100, Sheriff Esseson wrote:
> On Fri, Jun 28, 2019 at 10:43:24PM +0100, Sheriff Esseson wrote:
> > 	Convert xfs.txt to ReST, markup and rename accordingly. Update
> > 	Documentation/index.rst.

Don't quote the entire previous patch when submitting a new one.

> Rid Documentation/filesystems/index.rst of ".rst" in toc-tree references.
> 
> CC xfs-list.
> 
> Correct email indentation.

This text should be below the --- line, and it should be marked as "v2:"

And you didn't update the MAINTAINERS file.

> +For boolean mount options, the names with the "(*)" prefix is the
> +default behaviour. For example, take an behaviour enabled by default to be a one (1) or,

This line is too long.  Doesn't checkpatch.pl complain?

> +   rtdev=<device>
> +        An XFS filesystem has up to three parts: a data section, a log
> +	section, and a real-time section.  The real-time section is optional.
> +        If enabled, ``rtdev`` sets ``device`` to be used as an
> +        external real-time section, similar to ``logdev`` above.

Darrick mentioned the indentation was weird here, and you haven't fixed that.

> +   sunit=<value>
> +	Used to specify the stripe unit for a RAID device
> +	or (in conjunction with ``swidth`` below) a stripe volume.  ``value`` must be specified in 512-byte
> +	block units. This option is only relevant to filesystems

line length


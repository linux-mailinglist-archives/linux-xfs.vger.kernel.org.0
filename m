Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA255D25A
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2019 17:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfGBPE6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 11:04:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfGBPEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 11:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9Ig/WhFCMmBR2xXDMpzkQiPPTqzNwwKmWS6+MbIm22w=; b=pSiKJ2RruNBH4KzEsHjV0a5ZA
        bDxVLKFFnRFBgHKM0aj8BC3b1rHF1aozqWx0mXjhl28PYHuMuCiv/5qXj8ETrRNt+2MnO3KZtyB+w
        XOvwnbLGhEZT90YvowYY3BfVjxsaQctlZ/juwpJunqktd6cNWKzGpANh0+M1bRwCbzMNeN1dUJPZQ
        y6DBXHsaqTJHpWtvObwQk8prr3Pdo86frtbibbmhvYGX7D+Jk5+OfJ/rHXyTFG89IN6IwLwNKtcH8
        4C+5BG9SvcN3XiyTxQAOBwgyeZpB/HPQtLF6MhkNS5f70+2kRlo5DUvhI6NCKOApTs52jtsGokwKC
        B24N3RBlQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hiKKy-0007jy-ON; Tue, 02 Jul 2019 15:04:52 +0000
Date:   Tue, 2 Jul 2019 08:04:52 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [linux-kernel-mentees] [PATCH v5] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190702150452.GD1729@bombadil.infradead.org>
References: <20190702123040.GA30111@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702123040.GA30111@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 02, 2019 at 01:30:40PM +0100, Sheriff Esseson wrote:
> +When mounting an XFS filesystem, the following options are accepted.  For
> +boolean mount options, the names with the "(*)" prefix is the default behaviour.
> +For example, take a behaviour enabled by default to be a one (1) or, a zero (0)
> +otherwise, ``(*)[no]default`` would be 0 while ``[no](*)default`` , a 1.
> -When mounting an XFS filesystem, the following options are accepted.
> -For boolean mount options, the names with the (*) suffix is the
> -default behaviour.

You seem to have reflowed all the text.  That means git no longer notices
it's a rename, and quite frankly the shorter lines that were in use were
better.  This is not an improvement; please undo it in the next version
(which you should not post for several days to accumulate more feedback).

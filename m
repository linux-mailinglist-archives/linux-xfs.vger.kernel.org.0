Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B71BD11B1
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Oct 2019 16:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfJIOs7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Oct 2019 10:48:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51734 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbfJIOs7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:48:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LGZfmhHXUirw2+fTrk/qeyIrmIuOcBvyk4xp7GEyhG0=; b=j3NOJcxHbVzeMNVATmKmXlNsU
        Bn23Gcp/yCek9kRlArJtC+Ufgi2rKvB36G7SS5sxdHYvj/pGprJftuV3fy9Y4+NqoZLE+ZXMhLiND
        BQuahggA5p2FF5wFJ02U8bzKCOi1qhExWuBrF0WemjmvhZxWp6ZGQYgxsPE4r68vauG9+GGQPahak
        gAcYklRcuWfTz9ywJ+rxrqbI//+Hhixk+9j1s726rakbOgQnvCNrMGbB3muG16DvE6f3v6EIpMSoZ
        CEfDR4RyCGi7XMvoqtMF3ADiZPPSkkS53zFqSlzpulklVpNpe8p3jC2a2wvjIz69jrySuDDWKDkmu
        JTwcAKLhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDGt-0002wl-E0; Wed, 09 Oct 2019 14:48:59 +0000
Date:   Wed, 9 Oct 2019 07:48:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 05/17] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20191009144859.GB10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063684.32346.12253005903079702405.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062063684.32346.12253005903079702405.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:30:36PM +0800, Ian Kent wrote:
> The mount-api doesn't have a "human unit" parse type yet so
> the options that have values like "10k" etc. still need to
> be converted by the fs.

Any reason you don't lift it to the the core mount api code?

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923A0D8B30
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Oct 2019 10:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391431AbfJPIkK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Oct 2019 04:40:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389897AbfJPIkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wDBw/lIHsOFmQ5fkAEuJHbeEML7a2uwyEsUVLopSAL8=; b=DPFvRoYUTAgueBRuHU8lnYouj
        06ykdEWU3btSUcFkNRKNNnLszRh0xK3jxDffzlt2YQ4yBLyxeuXY+ooDMvMoQB4vCqeFA9NorOioU
        PptQcaHKsNYWVjShk/T1W4flYqB/bpgYwEqScg9aPoGH0mHRwleHMTrhfGxHEBWJnvFQZqhZcc/e3
        S7eS+7+rbJSr97FjuG2aYqhT41xKh6ViKFfeUzoBjEWAljKBvB9nQH1VHMoCIJBWMpKry4GN/aBLZ
        r9da2DqzpJA+RHNJtuteuz9B3Nyv1zzf7rOzZdJxxC3VXpE8WmdohkIP64RtCwULlVbtR0hDmYdLV
        eGtW/cG8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKeqn-0007oB-BU; Wed, 16 Oct 2019 08:40:09 +0000
Date:   Wed, 16 Oct 2019 01:40:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 10/12] xfs: move xfs_parseargs() validation to a helper
Message-ID: <20191016084009.GA21814@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118649791.9678.5158511909924114010.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118649791.9678.5158511909924114010.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:38AM +0800, Ian Kent wrote:
> +static int
> +xfs_validate_params(
> +	struct xfs_mount        *mp,
> +	int			dsunit,
> +	int			dswidth,
> +	uint8_t			iosizelog,
> +	bool			nooptions)

Please add a refactor patch before this one to always set the stripe
unit / width / log I/O size values in the mount structure at parsing
time as suggested before.  The will also remove the need for the
xfs_fs_context structure in the last patch.

> +	if (nooptions)
> +		goto noopts;

This option is always false in this patch.  I'd suggest you only add
it once we actually add a user.

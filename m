Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248E9D8AE8
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Oct 2019 10:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbfJPI1r (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Oct 2019 04:27:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46262 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729709AbfJPI1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IrvlUarzJWyDVPcf2TDMf6Wxai03BrbHeCTRIurcXeY=; b=ch8/Y0z2e2FEaC0ykdHSaAgZj
        LPopKEcHSoogH1pIatI4+o7cUDJERZIcKbzNcB6yv7zrLwohXsaT2KlERXXUoqYg+qk4rDqfqd17X
        fewZdzoE4viO2TGgfxXxtqlpuomwBBynRNpvvrqA+nDtgzEdLd8hE4aXx1foG+VU+IZodQgA2a3MS
        wGGO+fk7kGsnXEMAlmhNTytRqCQSuVkeVHZlhltMcoKY6pEBE9iVx+aXybcrskMoUzhTSTcQiILDn
        zzrMW88IL5SaTdPpYrbOpqZJS4SyW2CSY9pgTCpKRlQ3AWzUht24FT1Uxv/4a54hbAlIz0R+v+xk4
        pB+Ym+InQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKeeo-0001rA-Tt; Wed, 16 Oct 2019 08:27:46 +0000
Date:   Wed, 16 Oct 2019 01:27:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 04/12] xfs: use super s_id instead of mount info
 m_fsname
Message-ID: <20191016082746.GC29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118646315.9678.439818770752389112.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118646315.9678.439818770752389112.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Except for the mount info thing mentioned earlier:

Reviewed-by: Christoph Hellwig <hch@lst.de>

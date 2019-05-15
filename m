Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDB01E972
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 09:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfEOHxk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 03:53:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfEOHxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 03:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GhV//v9HiWEH2r8X3grNSMKQNqyzJEG4gdmxYnA2LQQ=; b=JYCMs0ZMKWLQ5EAx8Oo3E3qQT
        cEHP7RTwWRML/BaeHTsTjdgtqrOKjEgi/C3ZXkGXWiH1lplUDQru62Am56RmJ6BJmmGCwJxPZDQID
        UkBTF3jdgPPTmBrXReRw8y4J71zKiqgaqwRDNSdM07qX6IhZa4emWHSA7w2rZZHSmioO+y6muaqLz
        7tA0z5dPRd9n83JEHF4heckjKN2EaWrn5A2I9HMmixW0IBa6o0PkpOc0X2tD/LgTSiqDCv/mXJzuf
        0FfpP4bcB9ok0OTQVPy3YUf2gObPorcbv5l/+90XNyHPRhwjRDuF8aEaaftwKjf5JaOD/LfWdHrUG
        NKbsytQfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQojL-0005Ij-Nn; Wed, 15 May 2019 07:53:39 +0000
Date:   Wed, 15 May 2019 00:53:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: replace small allocation logic with agfl only
 logic
Message-ID: <20190515075339.GH29211@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-7-bfoster@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +out:
> +	if (error)
> +		trace_xfs_alloc_agfl_error(args);
> +	else
> +		trace_xfs_alloc_agfl_done(args);
>  	return error;

Splitting this into an out and an out_error label might be a little
nicer.  Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

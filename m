Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0B3170190
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2020 15:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgBZOuv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Feb 2020 09:50:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43430 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBZOuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 09:50:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=UtUC9d7cZWT4BRbWaLU+EiTUS1
        6+6Kd9gfBrL0gRs1/835RTvbJj2cvx8UJOLuLW/Bb6ES/okhRXF7YGi2X5GNzBTLwP8ZZgemX3RlV
        hjdulGXTgYSE5cZtMwV5mZGk9lkPbGfddFgpQUt6CcM4v7GZNPsBE/4eqTsA0ZpEhn+N4mX4Mb9Wm
        K2tELBaH7+KeOg2Ty2eOTxV4SeRcKiTCIF6w347CKoTyz9O7F0gtxGaD0J77R4QuxXOWb1kr/GBAz
        UZu/L868QpIA2J5dVIVH5+eJA3qYi6cxtd+Ov0n+JCj4SZYKXgnqLPJ64k2pzc5+aO7nf8Ee/kCkK
        6WZ+MyGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6y1Q-0004xx-CO; Wed, 26 Feb 2020 14:50:48 +0000
Date:   Wed, 26 Feb 2020 06:50:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Qian Cai <cai@lca.pw>
Cc:     darrick.wong@oracle.com, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xfs: fix an undefined behaviour in _da3_path_shift
Message-ID: <20200226145048.GA19034@infradead.org>
References: <20200226020637.1065-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226020637.1065-1-cai@lca.pw>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

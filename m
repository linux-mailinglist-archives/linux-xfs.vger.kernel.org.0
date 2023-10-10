Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7CC7BF3A2
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Oct 2023 09:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442386AbjJJHDI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Oct 2023 03:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442388AbjJJHDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 03:03:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BBB9F;
        Tue, 10 Oct 2023 00:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8vn93vZoq74cLEXJ1d94EKNd/VzlP496W547htMzN5Q=; b=y+Vs+D9Xu3KvjNujmaL0oDPun3
        zYe1iOWxDhGtwj7MTEPWjVVEgMJHBg3ocTjGxYWJcT7aUOJL5LheI4SYSSg56FNGbXSMnBEq1e5GC
        tIhh/6nwTlFY9WwkrGxn/NhunvWh2GYZNPIKr0lW2QUu+yAgCGgYyYQG2qnMzfQcmt+798mIKGz+b
        oL0qAnE/jrNgw7p2brKtb9M0UtEMN+gJDlgCxdGiMxb0Nnl/GHh1nA4qruwLdZoEqMXY//T3yPN+7
        snjYYm0BMkq3fhnFLJGVhUXqv6RqnYkY8JdrddQPV89fQSRNSpI27RKmi2dHhnYKTLQ3T3pIampMQ
        5ckzg/Wg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qq6lh-00CfI7-20;
        Tue, 10 Oct 2023 07:03:01 +0000
Date:   Tue, 10 Oct 2023 00:03:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, tytso@mit.edu, jack@suse.cz,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] generic/465: only complain about stale disk contents
 when racing directio
Message-ID: <ZST3JdoVWWxlrq3x@infradead.org>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
 <169687551965.3948976.15125603449708923383.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169687551965.3948976.15125603449708923383.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Yes, this looks sensible.  I've actually seen sproadic failures from
this test for a while and had this on my list to investigate.

Reviewed-by: Christoph Hellwig <hch@lst.de>

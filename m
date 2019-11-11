Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0895F7A87
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Nov 2019 19:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKKSKh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Nov 2019 13:10:37 -0500
Received: from verein.lst.de ([213.95.11.211]:50857 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbfKKSKh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Nov 2019 13:10:37 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id EE57D68B05; Mon, 11 Nov 2019 19:10:35 +0100 (CET)
Date:   Mon, 11 Nov 2019 19:10:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: devirtualize ->m_dirnameops
Message-ID: <20191111181035.GA21619@lst.de>
References: <20191111180415.22975-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111180415.22975-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sorry, this needs to go on top of the trivial
"xfs: remove the unused m_chsize field" patch I sent out just now.

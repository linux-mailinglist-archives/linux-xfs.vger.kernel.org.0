Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221F8201FDA
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Jun 2020 04:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731969AbgFTCif (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Jun 2020 22:38:35 -0400
Received: from p10link.net ([80.68.89.68]:44085 "EHLO P10Link.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgFTCif (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jun 2020 22:38:35 -0400
Received: from [192.168.1.2] (unknown [94.2.179.121])
        by P10Link.net (Postfix) with ESMTPSA id 5E2B240C004;
        Sat, 20 Jun 2020 03:38:33 +0100 (BST)
Subject: Re: Bug#953537: xfsdump fails to install in /usr merged system.
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
 <20200619044734.GB11245@magnolia>
From:   peter green <plugwash@p10link.net>
Message-ID: <8e4bd023-b3dc-0298-a1b7-81865fc4f3bc@p10link.net>
Date:   Sat, 20 Jun 2020 03:38:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200619044734.GB11245@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19/06/2020 05:47, Darrick J. Wong wrote:

>> I eventually poked around on git.kernel.org and my best guess is that
>> https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/ is the upstream
>> git repository and linux-xfs@vger.kernel.org is the appropriate
>> mailing list, I would appreciate comments on whether or not this is
>> correct and updates to the documentation to reflect whatever the
>> correct location is.
> 
> Yep, you've found us. :)
> 

Would it be too much to ask that the wiki is updated to mention xfsdump
and the README is updated so that people can find you more easilly in
future?

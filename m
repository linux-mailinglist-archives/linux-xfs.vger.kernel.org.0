Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D7DA9C92
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Sep 2019 10:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbfIEIGN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 04:06:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbfIEIGN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Sep 2019 04:06:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E14C63086208;
        Thu,  5 Sep 2019 08:06:12 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ED3460BE1;
        Thu,  5 Sep 2019 08:06:12 +0000 (UTC)
Date:   Thu, 5 Sep 2019 16:13:15 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jianhong Yin <jiyin@redhat.com>
Cc:     "Jianhong.Yin" <yin-jianhong@163.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfsprogs: copy_range: let = (src_size - src_offset)
 if len omitted
Message-ID: <20190905081315.GC7239@dhcp-12-102.nay.redhat.com>
References: <20190905053152.15701-1-yin-jianhong@163.com>
 <20190905053152.15701-2-yin-jianhong@163.com>
 <20190905060131.GB7239@dhcp-12-102.nay.redhat.com>
 <1290281207.12741020.1567663471691.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290281207.12741020.1567663471691.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 05 Sep 2019 08:06:12 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 02:04:31AM -0400, Jianhong Yin wrote:
> 
> 
> ----- ԭʼ�ʼ� -----
> > ������: "Zorro Lang" <zlang@redhat.com>
> > �ռ���: "Jianhong.Yin" <yin-jianhong@163.com>
> > ����: linux-xfs@vger.kernel.org, jiyin@redhat.com
> > ����ʱ��: ������, 2019�� 9 �� 05�� ���� 2:01:32
> > ����: Re: [PATCH 2/2] xfsprogs: copy_range: let = (src_size - src_offset) if len omitted
> > 
> > On Thu, Sep 05, 2019 at 01:31:52PM +0800, Jianhong.Yin wrote:
> > > add update man page.
> > > 
> > > Signed-off-by: Jianhong Yin <yin-jianhong@163.com>
> > > ---
> > 
> > I think these can be in one patch, but anyway...
> > 
> > >  io/copy_file_range.c | 7 +++++--
> > >  man/man8/xfs_io.8    | 9 +++------
> > >  2 files changed, 8 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > > index 283f5094..02d50e53 100644
> > > --- a/io/copy_file_range.c
> > > +++ b/io/copy_file_range.c
> > > @@ -72,6 +72,7 @@ copy_range_f(int argc, char **argv)
> > >  	long long src = 0;
> > >  	long long dst = 0;
> > >  	size_t len = 0;
> > > +	int len_ommited = 1;
> > >  	int opt;
> > >  	int ret;
> > >  	int fd;
> > > @@ -103,6 +104,7 @@ copy_range_f(int argc, char **argv)
> > >  				printf(_("invalid length -- %s\n"), optarg);
> > >  				return 0;
> > >  			}
> > > +			len_ommited = 0;
> > >  			break;
> > >  		case 'f':
> > >  			src_file_nr = atoi(argv[1]);
> > > @@ -128,7 +130,7 @@ copy_range_f(int argc, char **argv)
> > >  		fd = filetable[src_file_nr].fd;
> > >  	}
> > >  
> > > -	if (src == 0 && dst == 0 && len == 0) {
> > > +	if (len_ommited) {
> > >  		off64_t	sz;
> > >  
> > >  		sz = copy_src_filesize(fd);
> > > @@ -136,7 +138,8 @@ copy_range_f(int argc, char **argv)
> > >  			ret = 1;
> > >  			goto out;
> > >  		}
> > > -		len = sz;
> > > +		if (sz > src)
> > > +			len = sz - src;
> > 
> > What about file size < offset?
> just keep the default value 0,
> 
> because QE/tester might want to see what happen
> when give an offset(> fsize) to copy_file_range()
>   #note: This tool was made for test/debug copy_file_range()

Hmm, that's a good reason:)

> 
> Jianhong
> 
> > 
> > Maybe we can do like this?:
> > 
> >     sz = copy_src_filesize(fd);
> >     if (sz < 0 || (unsigned long long)sz > SIZE_MAX || sz < src) {
> >         ret = 1;
> >         goto out;
> >     }
> >     len = sz - src;
> > 
> > Thanks,
> > Zorro
> > 
> > >  	}
> > >  
> > >  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> > > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > > index 6e064bdd..f5f1c4fc 100644
> > > --- a/man/man8/xfs_io.8
> > > +++ b/man/man8/xfs_io.8
> > > @@ -669,13 +669,10 @@ The source must be specified either by path
> > >  or as another open file
> > >  .RB ( \-f ).
> > >  If
> > > -.I src_file
> > > -.IR src_offset ,
> > > -.IR dst_offset ,
> > > -and
> > >  .I length
> > > -are omitted the contents of src_file will be copied to the beginning of
> > > the
> > > -open file, overwriting any data already there.
> > > +is omitted will use
> > > +.I src_file
> > > +(file size - src_offset) instead.
> > >  .RS 1.0i
> > >  .PD 0
> > >  .TP 0.4i
> > > --
> > > 2.21.0
> > > 
> > 
